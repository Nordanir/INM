import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/search_provider.dart';
import 'package:provider/provider.dart';

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
      child: SizedBox(
        width: AppDimensions.albumCardWidth(context),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: lightGreen, width: 3),
          ),
          child: Image.network(
            album.coverUrl,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.music_note);
            },
          ),
        ),
      ),
    );
  }
}


class DisplayAlbums extends StatelessWidget {
 final AlbumProvider albumProvider ;
  const DisplayAlbums({super.key, required this.albumProvider});

  @override
  Widget build(BuildContext context) {
    return albumProvider.albums.isEmpty
        ? const Center(child: Text("No albums found :("))
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            scrollDirection: Axis.vertical,
            itemCount: albumProvider.albums.length,
            itemBuilder: (context, index) {
              final album = albumProvider.albums[index];
              return SizedBox(
                width: AppDimensions.albumCardWidth(context),
                child: AlbumCard(album: album),
              );
            },
          );
  }
}
