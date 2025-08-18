import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/classes/album.dart';
import 'package:frontend/classes/entity.dart';
import 'package:frontend/classes/track.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/providers/selection_provider.dart';
import 'package:frontend/providers/superbase_config.dart';
import 'package:frontend/providers/album_provider.dart';
import 'package:frontend/providers/search_provider.dart';
import 'package:frontend/widgets/util.dart';
import 'package:provider/provider.dart';

class InfoPanel extends StatelessWidget {
  const InfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final selectionProvider = Provider.of<SelectionProvider>(context);
    final album = selectionProvider.selectedAlbum;

    if (album == null) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      width: InfoPanelDimensions.infoPanelWidth(context),
      height: InfoPanelDimensions.infoPanelHeight(context),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xff7092BE).withValues(alpha: 0.7),
            spreadRadius: 5,
            blurRadius: 1,
            offset: Offset(-3, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.all(AppDimensions.infoPanelBorderRadius),
        border: Border.all(color: black),
        color: lightBlueHighlight,
      ),
      child: (selectionProvider.selectedTrack == null)
          ? TrackList(album: album)
          : TrackInfo(),
    );
  }
}

class DisplayText extends StatelessWidget {
  const DisplayText({
    super.key,
    required this.text,
    this.label,
    this.align = TextAlign.left,
    this.textsize = 18,
    this.letterSpacing = 1.5,
  });
  final String text;
  final String? label;
  final TextAlign align;
  final double textsize;
  final double letterSpacing;
  @override
  Widget build(BuildContext context) {
    return Text(
      label != null ? "$label  $text" : text,
      textAlign: align,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: black,
        fontSize: textsize,
        fontFamily: "Inconsolata",
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

class TrackList extends StatefulWidget {
  const TrackList({super.key, required this.album});
  final Album album;

  @override
  State<TrackList> createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  bool isRatingBoxDisplayed = false;
  void displayRatingBox() {
    setState(() {
      isRatingBoxDisplayed = !isRatingBoxDisplayed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectionProvider = Provider.of<SelectionProvider>(context);

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              width: InfoPanelDimensions.infoPanelContentWidth(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: InfoPanelDimensions.infoPanelHeight(context) * .15,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: selectionProvider.selectedAlbum!.cover,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScrollableText(
                        text: widget.album.title,
                        areaWidth: InfoPanelDimensions.scrollableTitleWidth(
                          context,
                        ),
                      ),
                      DisplayText(
                        label: duration,
                        text: displayDuration(widget.album.duration),
                        align: TextAlign.left,
                        letterSpacing: 2.5,
                      ),
                      DisplayText(
                        label: numOfTracks,
                        text: widget.album.numberOfTracks.toString(),
                        align: TextAlign.left,
                        letterSpacing: 2.5,
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      AddOrRemoveEntryButton(),
                      SizedBox(
                        height:
                            InfoPanelDimensions.entryButtonHeight(context) / 2,
                      ),
                      RatingsButton(
                        entity: selectionProvider.selectedAlbum!,
                        function: displayRatingBox,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsetsGeometry.fromLTRB(0, 20, 0, 10),
              child: Divider(color: secondaryBlue, thickness: 4),
            ),
            const SizedBox(height: 20),
            (widget.album.tracks.isNotEmpty)
                ? DisplayTracks(album: widget.album)
                : DisplayText(text: "No tracks available"),
          ],
        ),
        isRatingBoxDisplayed == true
            ? Positioned(
                left:
                    InfoPanelDimensions.infoPanelContentWidth(context) -
                    InfoPanelDimensions.ratingBoxWidth(context),
                top: InfoPanelDimensions.infoPanelContentHeight(context) * .2,
                child: RatingBox(entity: selectionProvider.selectedAlbum!),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

class DisplayTracks extends StatelessWidget {
  final Album album;
  const DisplayTracks({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: InfoPanelDimensions.infoPanelContentWidth(context),
      height: InfoPanelDimensions.trackListHeight(context),
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemCount: album.tracks.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, int index) {
          return TrackCard(track: album.tracks[index]);
        },
      ),
    );
  }
}

class TrackCard extends StatefulWidget {
  final Track track;
  const TrackCard({super.key, required this.track});

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final selectionProvider = Provider.of<SelectionProvider>(context);
    return MouseRegion(
      onEnter: (_) => {
        setState(() {
          isHovered = true;
        }),
      },

      onExit: (_) => {
        setState(() {
          isHovered = false;
        }),
      },
      child: GestureDetector(
        onTap: () {
          selectionProvider.changeSelectedTrack(widget.track);
        },

        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isHovered ? primaryBlue : Color(0xffA7BFDC),
            boxShadow: [
              BoxShadow(
                //here
                color: Color.fromARGB(255, 56, 74, 100),
                blurRadius: 1,
                blurStyle: BlurStyle.inner,
                spreadRadius: 1,
                offset: Offset(-1, 1),
              ),
            ],
            border: Border.all(color: Color.fromARGB(255, 134, 162, 200)),
          ),
          height: AppDimensions.trackCardHeight(),
          padding: EdgeInsets.all(4),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Positioned(
                left: 10,
                child: DisplayText(text: '${widget.track.numberOnTheAlbum}.'),
              ),
              Positioned(
                left: AppDimensions.trackTitlePosition(),
                right: AppDimensions.trackTitleSpan(),
                child: DisplayText(text: widget.track.title),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrackInfo extends StatelessWidget {
  const TrackInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final selectionProvider = Provider.of<SelectionProvider>(context);

    final track = selectionProvider.selectedTrack!;
    final album = selectionProvider.selectedAlbum!;
    return Container(
      width: InfoPanelDimensions.trackInfoPanelIWitdth(context),
      height: InfoPanelDimensions.infoPanelHeight(context),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: deepBlueHighLight.withValues(alpha: 0.7),
            spreadRadius: 5,
            blurRadius: 1,
            offset: Offset(-3, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.all(AppDimensions.infoPanelBorderRadius),
        border: Border.all(color: black),
        color: lightBlueHighlight,
      ),
      child: Column(
        children: [
          CloseButton(),
          Column(
            children: [
              DisplayText(text: track.title),
              const SizedBox(height: 15),
              DisplayText(
                text: "${album.title} - ${track.numberOnTheAlbum}. track",
              ),
            ],
          ),
          const SizedBox(height: 15),
          Divider(thickness: 4, color: deepBlueHighLight),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: InfoPanelDimensions.closeTrackInfoButtonWidth(context),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: deepBlueHighLight, width: 1),
                ),
                width: InfoPanelDimensions.trackInfoCoverWidth(context),
                height: InfoPanelDimensions.trackInfoCoverWidth(context),
                child: album.cover,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DisplayText(
                    text: displayDuration(track.duration),
                    label: "Duration : ",
                  ),
                  if (track.isASingle) DisplayText(text: "Single"),
                  if (track.isALive) DisplayText(text: "Live"),
                  DisplayText(text: "Genres : "),
                  DisplayText(text: "Record Label : "),
                  DisplayText(text: "Producer :"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddOrRemoveEntryButton extends StatelessWidget {
  const AddOrRemoveEntryButton({super.key});
  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context, listen: true);
    final searchProvider = Provider.of<SearchProvider>(context, listen: true);
    final supabase = Provider.of<SupabaseConfig>(context, listen: true);
    final selectionProvider = Provider.of<SelectionProvider>(context);

    return SizedBox(
      width: InfoPanelDimensions.entryButtonWidth(context),
      height: InfoPanelDimensions.entryButtonHeight(context),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.hovered)) {
              return Color(0xff7092BE);
            }
            return Color(0xffA7BFDC);
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(9)),
            ),
          ),
          alignment: Alignment.center,
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
        ),
        onPressed: () async {
          if (searchProvider.isSearching) {
            Provider.of<SupabaseConfig>(
              context,
              listen: false,
            ).addAlbumToDatabase(selectionProvider.selectedAlbum!);
          } else {
            await albumProvider.deleteAlbum(
              selectionProvider.selectedAlbum!,
              supabase,
            );
            selectionProvider.changeSelectedAlbum(null);
          }
        },
        child: (searchProvider.isSearching)
            ? Icon(Icons.add)
            : const Icon(Icons.close),
      ),
    );
  }
}

class CloseButton extends StatelessWidget {
  const CloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final selectionProvider = Provider.of<SelectionProvider>(context);
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black),
            right: BorderSide(color: black),
          ),
          borderRadius: BorderRadius.only(bottomRight: Radius.elliptical(4, 8)),
        ),
        height: InfoPanelDimensions.closeTrackInfoButtonHeight(context),
        width: InfoPanelDimensions.closeTrackInfoButtonWidth(context),
        child: IconButton(
          style: IconButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () {
            selectionProvider.changeSelectedTrack(null);
          },
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.close),
        ),
      ),
    );
  }
}

class RatingsButton extends StatefulWidget {
  final Entity entity;
  final Function function;
  const RatingsButton({
    super.key,
    required this.entity,
    required this.function,
  });

  @override
  State<RatingsButton> createState() => _RatingsButtonState();
}

class _RatingsButtonState extends State<RatingsButton> {
  bool _isHovered = false;

  Color get color {
    if (_isHovered) {
      return deepBlueHighLight;
    } else {
      return widget.entity.rating == null ? lightBlueHighlight : blue1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          widget.function();
        },
        child: Container(
          height: InfoPanelDimensions.entryButtonHeight(context),
          width: InfoPanelDimensions.entryButtonWidth(context),
          decoration: ShapeDecoration(
            color: color,
            shape: StarBorder(
              side: BorderSide(color: deepBlueHighLight),
              points: 5,
              rotation: 0,
              innerRadiusRatio: .5,
              pointRounding: .1,
            ),
          ),
          child: widget.entity.rating != null
              ? Text(widget.entity.rating.toString())
              : null,
        ),
      ),
    );
  }
}

class RatingBox extends StatelessWidget {
  const RatingBox({super.key, required this.entity});
  final Entity entity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      width: InfoPanelDimensions.ratingBoxWidth(context),
      height: InfoPanelDimensions.ratingBoxHeight(context),
      decoration: BoxDecoration(
        color: lightBlueHighlight,
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          for (var i = 0; i < 5; i++)
            RatingsButton(
              entity: entity,
              function: () {
                entity.updateRating(i.toDouble());
              },
            ),
        ],
      ),
    );
  }
}
