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
import 'package:frontend/widgets/auth.dart';
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
        boxShadow: [AppDimensions.containershadow],
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
    this.textsize = AppDimensions.normalFontSize,
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
      style: textStyle(textsize),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

TextStyle textStyle(double textsize) {
  return TextStyle(
    fontWeight: AppDimensions.normalWeight,
    color: black,
    fontSize: textsize,
    fontFamily: "Inconsolata",
  );
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

  void hideRatingBox() {
    setState(() {
      isRatingBoxDisplayed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectionProvider = Provider.of<SelectionProvider>(context);
    final searchProvider = Provider.of<SearchProvider>(context);
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
                      border: Border.all(width: AppDimensions.outlineWidth),
                    ),
                    child: selectionProvider.selectedAlbum!.cover,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScrollableText(
                        textSize: AppDimensions.emphasizedFontSize,
                        text: widget.album.title,
                        areaWidth: InfoPanelDimensions.scrollableTitleWidth(
                          context,
                        ),
                        fontWeight: AppDimensions.emphasizedWeight,
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
                      if (!searchProvider.isSearching)
                        RatingsButton(
                          entity: selectionProvider.selectedAlbum!,
                          function: displayRatingBox,
                          child: selectionProvider.selectedAlbum!.rating != 0
                              ? DisplayText(
                                  text: selectionProvider.selectedAlbum!.rating!
                                      .toInt()
                                      .toString(),
                                )
                              : SizedBox.shrink(),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsetsGeometry.fromLTRB(0, 20, 0, 10),
              child: Divider(
                color: deepBlueHighLight.withValues(alpha: .3),
                thickness: AppDimensions.outlineWidth,
              ),
            ),
            SizedBox(height: AppDimensions.normalSpacing(context)),
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
                child: RatingBox(
                  entity: selectionProvider.selectedAlbum!,
                  onRated: hideRatingBox,
                ),
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
            color: isHovered ? accent : lightBlueHighlight,
            boxShadow: [
              BoxShadow(
                //here
                color: deepBlueHighLight,
                blurRadius: 1,
                blurStyle: BlurStyle.inner,
                spreadRadius: 1,
                offset: Offset(-1, 1),
              ),
            ],
            border: Border.all(color: deepBlueHighLight),
          ),
          height: AppDimensions.trackCardHeight(),
          padding: AppDimensions.smallPadding,
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
              SizedBox(height: AppDimensions.normalSpacing(context)),
              DisplayText(
                text: "${album.title} - ${track.numberOnTheAlbum}. track",
              ),
            ],
          ),
          SizedBox(height: AppDimensions.normalSpacing(context)),
          Divider(thickness: 4, color: deepBlueHighLight),
          SizedBox(height: AppDimensions.largeSpacing(context)),
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
              return accent;
            }
            return lightBlueHighlight;
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
            final response = await Provider.of<SupabaseConfig>(
              context,
              listen: false,
            ).addAlbumToDatabase(selectionProvider.selectedAlbum!);

            showSnackBar(response, context);
          } else {
            await albumProvider.deleteAlbum(
              selectionProvider.selectedAlbum!,
              supabase,
            );
            showSnackBar(
              albumDeleted(selectionProvider.selectedAlbum!),
              context,
            );
            selectionProvider.changeSelectedAlbum(null);
          }
        },
        child: (searchProvider.isSearching)
            ? Icon(Icons.add)
            : const Icon(Icons.remove),
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
            bottom: BorderSide(color: black),
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

class RatingsButton extends StatelessWidget {
  final Widget child;
  final Entity entity;
  final VoidCallback function;
  final bool filled;
  const RatingsButton({
    super.key,
    this.child = const SizedBox.shrink(),
    required this.entity,
    required this.function,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = filled ? accent : lightBlueHighlight;
    return GestureDetector(
      onTap: function,
      child: Container(
        height: InfoPanelDimensions.entryButtonHeight(context) * 1.1,
        width: InfoPanelDimensions.entryButtonWidth(context) * 1.1,
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
        alignment: Alignment.center, // Center the child
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: AppDimensions.smallFontSize, // Smaller font size to fit
              color: black,
              fontWeight: FontWeight.bold,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class RatingBox extends StatefulWidget {
  const RatingBox({super.key, required this.entity, required this.onRated});
  final Entity entity;
  final VoidCallback onRated;

  @override
  State<RatingBox> createState() => _RatingBoxState();
}

class _RatingBoxState extends State<RatingBox> {
  int hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimensions.smallPadding,
      width: InfoPanelDimensions.ratingBoxWidth(context),
      height: InfoPanelDimensions.ratingBoxHeight(context),
      decoration: BoxDecoration(
        color: lightBlueHighlight,
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < 5; i++)
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  hoveredIndex = i;
                });
              },
              onExit: (_) {
                setState(() {
                  hoveredIndex = -1;
                });
              },
              child: RatingsButton(
                entity: widget.entity,
                function: () async {
                  widget.entity.rating = i.toDouble() + 1;
                  await Provider.of<SupabaseConfig>(
                    context,
                    listen: false,
                  ).setRatingOfEntity(widget.entity, i.toDouble() + 1);
                  widget.onRated();
                },
                filled: i <= hoveredIndex,
              ),
            ),
        ],
      ),
    );
  }
}
