import 'package:flutter/material.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/search_provider.dart';
import 'package:provider/provider.dart';

class SearchEntryOnline extends StatelessWidget {
  const SearchEntryOnline({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    final albumProvider = Provider.of<AlbumProvider>(context);
    return SearchBar(
      onSubmitted: (value) {
        searchProvider.searchFor().then((futureAlbums) {
          albumProvider.albums = futureAlbums;
          searchProvider.isSearching = true;
          albumProvider.changeSelectedAlbum(null);
        });
      },
      onChanged: (value) {
        searchProvider.setQuerry(value);
      },
    );
  }
}
