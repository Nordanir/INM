import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/widgets/album_provider.dart';

class AlbumCard extends StatelessWidget {
  final String url;
  const AlbumCard({
    super.key,
    this.url = "https://discussions.apple.com/content/attachment/881765040",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        width: AppDimensions.albumCardWidth(context),
        child: Container(color: Colors.black, child: Image.network(url)),
      ),
    );
  }
}

class DisplayAlbums extends StatelessWidget {
  late AlbumProvider albumProvider;
  DisplayAlbums({super.key, required this.albumProvider});

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
                child: AlbumCard(url: album.coverUrl),
              );
            },
          );
  }
}
