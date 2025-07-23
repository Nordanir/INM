import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/info_panel.dart';
import 'package:frontend/widgets/search_provider.dart';
import 'package:frontend/widgets/util.dart';
import 'package:provider/provider.dart';

// This widget displays an album as a panel with cover art
class AlbumCard extends StatelessWidget {
  final Album album;
  const AlbumCard({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: true);
    final albumProvider = Provider.of<AlbumProvider>(context, listen: true);
    return GestureDetector(
      onTap: () async {
        if (album.tracks.isEmpty) {
          await searchProvider.retrieveSongs(album);
          albumProvider.changeSelectedAlbum(album);
        }
        albumProvider.changeSelectedAlbum(album);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: lightGreen, width: 3),
          color: Color(0xFF5f91d0),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: AppDimensions.albumCardWidth(context) * .70,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    album.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.music_note);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            DisplayText(
              text: album.title,
              label: "Album Title",
              align: TextAlign.center,
            ),
            DisplayText(
              text: displayDuration(album.duration),
              label: "Duration",
              align: TextAlign.center,
            ),
            DisplayText(
              text: album.numberOfTracks.toString(),
              label: "",
              align: TextAlign.center,
            ),
          ],
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
                crossAxisCount: 3,
                childAspectRatio: 0.9, // Adjusted for rectangular cards
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
