import 'package:flutter/material.dart';
import 'package:frontend/classes/album.dart';
import 'package:frontend/classes/artist.dart';
import 'package:frontend/classes/entity.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/dimensions/content_list_dimensions.dart';
import 'package:frontend/providers/display_provider.dart';
import 'package:frontend/themes/text_theme.dart';
import 'package:frontend/utils/text_display_widgets.dart';
import 'package:frontend/utils/time_display.dart';
import 'package:provider/provider.dart';

// This widget displays an album as a panel with cover art
class AlbumCard extends StatefulWidget {
  final Album album;
  const AlbumCard({super.key, required this.album});

  @override
  State<AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<AlbumCard> {
  @override
  Widget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom: AppDimensions.smallSpacing,
            top: AppDimensions.normalSpacing(context),
          ),
          width: ContentListDimensions.albumCardPictureWidth(context),
          decoration: BoxDecoration(
            border: Border.all(color: black, width: AppDimensions.outlineWidth),
          ),
          child: AspectRatio(aspectRatio: 1, child: widget.album.cover),
        ),
        SizedBox(
          width: ContentListDimensions.albumCardTextBoxWidth(context),
          child: DisplayText(
            maxLines: 2,
            text: widget.album.title,
            textAlign: TextAlign.center,
            textStyle: currentTheme.textTheme.titleLarge?.copyWith(
              fontSize: largeTitleFontSize(context),
            ),
          ),
        ),
        Spacer(),
        Row(
          children: [
            Row(
              children: [
                Icon(Icons.timer, size: normalFontSize(context)),
                DisplayText(
                  text: displayDuration(widget.album.duration),
                  textAlign: TextAlign.center,
                  textStyle: currentTheme.textTheme.bodySmall?.copyWith(
                    color: currentTheme.hintColor,
                    fontSize: smallFontSize(context),
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                DisplayText(
                  text: widget.album.numberOfTracks.toString(),
                  textAlign: TextAlign.center,
                  textStyle: currentTheme.textTheme.bodySmall?.copyWith(
                    color: currentTheme.hintColor,
                    fontSize: smallFontSize(context),
                  ),
                ),
                Icon(Icons.music_note, size: normalFontSize(context)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class DisplayCard extends StatefulWidget {
  const DisplayCard({super.key, required this.entity});
  final Entity entity;
  @override
  State<DisplayCard> createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final displayProvider = Provider.of<DisplayProvider>(context, listen: true);
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          displayProvider.changeSelectedTrack(null);
          displayProvider.changeSelectedEntity(widget.entity);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: AppDimensions.smallPadding,
          decoration: BoxDecoration(
            borderRadius: ContentListDimensions.albumCardBorderRadius(),
            border: Border.all(color: black, width: AppDimensions.outlineWidth),
            color: isHovered ? accent : lightBlueHighlight,
          ),
          child: Builder(
            builder: (context) {
              if (widget.entity is Album) {
                return AlbumCard(album: widget.entity as Album);
              } else if (widget.entity is Artist) {
                return ArtistCard(artist: widget.entity as Artist);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

class ArtistCard extends StatefulWidget {
  const ArtistCard({super.key, required this.artist});
  final Artist artist;

  @override
  State<ArtistCard> createState() => _ArtistCardState();
}

class _ArtistCardState extends State<ArtistCard> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        DisplayText(
          text: widget.artist.title,
          textStyle: textTheme.titleMedium,
        ),
      ],
    );
  }
}

// This widget displays all albums recieved from database as a grid
class DisplayAlbums extends StatelessWidget {
  const DisplayAlbums({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DisplayProvider>(
      builder: (context, displayProvider, child) {
        if (displayProvider.displayEntities.isEmpty) {
          return Center(child: Text(noEntriesFound));
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: .80, // Adjusted for rectangular cards
              crossAxisSpacing: 16, // Increased spacing
              mainAxisSpacing: 16, // Increased spacing
            ),
            scrollDirection: Axis.vertical,
            itemCount: displayProvider.displayEntities.length,
            itemBuilder: (context, index) {
              return DisplayCard(
                entity: displayProvider.displayEntities[index],
              );
            },
          );
        }
      },
    );
  }
}
