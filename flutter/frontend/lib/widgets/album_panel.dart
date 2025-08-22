import 'package:flutter/material.dart';
import 'package:frontend/classes/album.dart';
import 'package:frontend/constants/assets.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/dimensions/content_list_dimensions.dart';
import 'package:frontend/providers/album_provider.dart';
import 'package:frontend/providers/selection_provider.dart';
import 'package:frontend/widgets/info_panel.dart';
import 'package:frontend/widgets/util.dart';
import 'package:provider/provider.dart';

// This widget displays an album as a panel with cover art
class AlbumCard extends StatefulWidget {
  final Album album;
  const AlbumCard({super.key, required this.album});

  @override
  State<AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<AlbumCard> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final selectionProvider = Provider.of<SelectionProvider>(
      context,
      listen: true,
    );
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
          selectionProvider.changeSelectedTrack(null);
          selectionProvider.changeSelectedAlbum(widget.album);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: AppDimensions.smallPadding,
          decoration: BoxDecoration(
            boxShadow: [AppDimensions.containershadow],
            borderRadius: ContentListDimensions.albumCardBorderRadius(),
            border: Border.all(color: black, width: AppDimensions.outlineWidth),
            color: isHovered ? accent : lightBlueHighlight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: AppDimensions.smallSpacing, top: AppDimensions.normalSpacing(context)),
                width: ContentListDimensions.albumCardPictureWidth(context),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: black,
                    width: AppDimensions.outlineWidth,
                  ),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    widget.album.coverUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(defaultCoverPath);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: ContentListDimensions.albumCardTextBoxWidth(context),
                child: Center(
                  child: DisplayText(
                    text: widget.album.title,
                    align: TextAlign.center,
                  ),
                ),
              ),
              DisplayText(
                text: displayDuration(widget.album.duration),
                align: TextAlign.center,
              ),
              DisplayText(
                text: widget.album.numberOfTracks.toString(),
                align: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// This widget displays all albums recieved from database as a grid
class DisplayAlbums extends StatelessWidget {
  const DisplayAlbums({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumProvider>(
      builder: (context, albumProvider, child) {
        if (albumProvider.displayingAlbums.isEmpty) {
          return const Center(child: Text("No albums found :("));
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: .80, // Adjusted for rectangular cards
              crossAxisSpacing: 16, // Increased spacing
              mainAxisSpacing: 16, // Increased spacing
            ),
            scrollDirection: Axis.vertical,
            itemCount: albumProvider.displayingAlbums.length,
            itemBuilder: (context, index) {
              return AlbumCard(album: albumProvider.displayingAlbums[index]);
            },
          );
        }
      },
    );
  }
}
