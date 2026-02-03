import 'package:flutter/material.dart';
import 'package:frontend/classes/album.dart';
import 'package:frontend/classes/entity.dart';
import 'package:frontend/classes/track.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/providers/display_provider.dart';
import 'package:frontend/providers/superbase_config.dart';
import 'package:frontend/providers/search_provider.dart';
import 'package:frontend/themes/text_theme.dart';
import 'package:frontend/utils/text_display_widgets.dart';
import 'package:frontend/widgets/auth.dart';
import 'package:frontend/utils/time_display.dart';
import 'package:provider/provider.dart';

class InfoPanel extends StatelessWidget {
  const InfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final displayProvider = Provider.of<DisplayProvider>(context);
    final entity = displayProvider.selectedEntity;

    if (entity == null) return const SizedBox.shrink();
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
      child: Builder(
        builder: (context) {
          if (entity is Album) {
            return AlbumInfo(album: entity);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class AlbumInfo extends StatefulWidget {
  const AlbumInfo({super.key, required this.album});
  final Album album;

  @override
  State<AlbumInfo> createState() => _AlbumInfoState();
}

class _AlbumInfoState extends State<AlbumInfo> {
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
    final TextTheme currentTheme = Theme.of(context).textTheme;
    final displayProvider = Provider.of<DisplayProvider>(context);
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
                    child: widget.album.cover,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScrollableText(
                        text: widget.album.title,
                        textStyle: currentTheme.titleMedium!,
                      ),
                      DisplayText(
                        text: displayDuration(widget.album.duration),
                        letterSpacing: 2.5,
                        textStyle: currentTheme.bodyMedium,
                      ),
                      DisplayText(
                        text: widget.album.numberOfTracks.toString(),
                        textAlign: TextAlign.left,
                        textStyle: currentTheme.bodyMedium,
                        letterSpacing: 2.5,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      const AddOrRemoveEntryButton(),
                      SizedBox(
                        height:
                            InfoPanelDimensions.entryButtonHeight(context) / 2,
                      ),
                      if (!searchProvider.isSearching)
                        RatingsButton(
                          entity: displayProvider.selectedEntity!,
                          function: displayRatingBox,
                          child: displayProvider.selectedEntity!.rating != 0
                              ? DisplayText(
                                  text: displayProvider.selectedEntity!.rating!
                                      .toInt()
                                      .toString(),
                                  textStyle: currentTheme.titleMedium,
                                )
                              : const SizedBox.shrink(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Divider(
                color: deepBlueHighLight.withAlpha((.3 * 255).toInt()),
                thickness: AppDimensions.outlineWidth,
              ),
            ),
            SizedBox(height: AppDimensions.normalSpacing(context)),
            (widget.album.tracks.isNotEmpty)
                ? DisplayTracks(album: widget.album)
                : DisplayText(
                    text: noTracksAvailable,
                    textStyle: currentTheme.labelLarge,
                  ),
          ],
        ),
        isRatingBoxDisplayed == true
            ? Positioned(
                left:
                    InfoPanelDimensions.infoPanelContentWidth(context) -
                    InfoPanelDimensions.ratingBoxWidth(context),
                top: InfoPanelDimensions.infoPanelContentHeight(context) * .2,
                child: RatingBox(
                  entity: displayProvider.selectedEntity!,
                  onRated: hideRatingBox,
                ),
              )
            : SizedBox.shrink(),

        displayProvider.selectedTrack != null
            ? Positioned(
                left: InfoPanelDimensions.infoPanelWidth(context) * .1,
                top: 0,
                child: TrackInfo(
                  album: widget.album,
                  track: displayProvider.selectedTrack!,
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
    final TextTheme currentTheme = Theme.of(context).textTheme;
    final displayProvider = Provider.of<DisplayProvider>(context);
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
          displayProvider.changeSelectedTrack(widget.track);
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
                child: DisplayText(
                  text: '${widget.track.numberOnTheAlbum}.',
                  textStyle: currentTheme.bodyMedium,
                ),
              ),
              Positioned(
                left: AppDimensions.trackTitlePosition(),
                right: AppDimensions.trackTitleSpan(),
                child: DisplayText(
                  text: widget.track.title,
                  textStyle: currentTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrackInfo extends StatelessWidget {
  const TrackInfo({super.key, required this.album, required this.track});
  final Album album;
  final Track track;
  @override
  Widget build(BuildContext context) {
    final TextTheme currentTheme = Theme.of(context).textTheme;
    return Container(
      width: InfoPanelDimensions.trackInfoPanelIWitdth(context),
      height: InfoPanelDimensions.infoPanelHeight(context) / 2,
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
              DisplayText(
                text: track.title,
                textStyle: currentTheme.titleMedium,
              ),
              SizedBox(height: AppDimensions.normalSpacing(context)),
              DisplayText(
                text: titleNthTrackOnTheAlbum(album, track),
                textStyle: currentTheme.bodyMedium,
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
                    textStyle: currentTheme.bodyMedium,
                  ),
                  if (track.isASingle)
                    DisplayText(
                      text: "Single",
                      textStyle: currentTheme.labelMedium,
                    ),
                  if (track.isALive)
                    DisplayText(
                      text: "Live",
                      textStyle: currentTheme.labelMedium,
                    ),
                  DisplayText(
                    text: "Genres : ",
                    textStyle: currentTheme.labelMedium,
                  ),
                  DisplayText(
                    text: "Record Label : ",
                    textStyle: currentTheme.labelMedium,
                  ),
                  DisplayText(
                    text: "Producer :",
                    textStyle: currentTheme.labelMedium,
                  ),
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
    final searchProvider = Provider.of<SearchProvider>(context, listen: true);
    final supabase = Provider.of<SupabaseConfig>(context, listen: true);
    final displayProvider = Provider.of<DisplayProvider>(context);

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
            ).addEntityToDatabase(displayProvider.selectedEntity!);

            showSnackBar(response, context);
          } else {
            await supabase.removeEntity(displayProvider.selectedEntity!);
            showSnackBar(
              entityDeleted(displayProvider.selectedEntity!),
              context,
            );
            displayProvider.changeSelectedEntity(null);
          }
        },
        child: (searchProvider.isSearching)
            ? Icon(Icons.add)
            : const Icon(Icons.remove),
      ),
    );
  }
}

class CloseButton extends StatefulWidget {
  const CloseButton({super.key});

  @override
  State<CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<CloseButton> {
  bool isHovered = false;

  void hover() {
    setState(() {
      isHovered = !isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayProvider = Provider.of<DisplayProvider>(context);
    return Align(
      alignment: Alignment.topLeft,
      child: MouseRegion(
        onEnter: (_) => {hover()},
        onExit: (_) => {hover()},
        child: Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: isHovered ? accent : lightBlueHighlight,
            border: Border(
              bottom: BorderSide(color: black),
              right: BorderSide(color: black),
            ),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.elliptical(4, 8),
            ),
          ),
          height: InfoPanelDimensions.closeTrackInfoButtonHeight(context),
          width: InfoPanelDimensions.closeTrackInfoButtonWidth(context),
          child: IconButton(
            style: IconButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () {
              displayProvider.changeSelectedTrack(null);
            },
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.close),
          ),
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
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: smallFontSize(context),
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
