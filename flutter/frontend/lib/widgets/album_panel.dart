import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/dimensions/content_list_dimensions.dart';
import 'package:frontend/widgets/album_provider.dart';
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
    final albumProvider = Provider.of<AlbumProvider>(context, listen: true);
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
        onTap: () async {
          if (widget.album.tracks.isEmpty) {
            albumProvider.changeSelectedAlbum(widget.album);
          }
          albumProvider.changeSelectedTrack(null);
          albumProvider.changeSelectedAlbum(widget.album);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
              bottom: Radius.circular(16),
            ),
            border: Border.all(color: Color(0xff6972D8), width: 3),
            color: isHovered ? lightBlueHighlight : blue1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10, top: 20),
                width: ContentListDimesions.albumCardPictureWidth(context),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    widget.album.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/default.png");
                    },
                  ),
                ),
              ),
              SizedBox(
                width: ContentListDimesions.albumCardTextBoxWidth(context),
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: .75, // Adjusted for rectangular cards
                crossAxisSpacing: 16, // Increased spacing
                mainAxisSpacing: 16, // Increased spacing
              ),
              scrollDirection: Axis.vertical,
              itemCount: albumProvider.displayingAlbums.length,
              itemBuilder: (context, index) {
                return AlbumCard(album: albumProvider.displayingAlbums[index]);
              },
            ),
          );
        }
      },
    );
  }
}
