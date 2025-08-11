import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/search_provider.dart';
import 'package:provider/provider.dart';

class SearchEntryOnline extends StatelessWidget {
  const SearchEntryOnline({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    final albumProvider = Provider.of<AlbumProvider>(context);
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: AppDimensions.sideContainerHeight(context) * .1,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xff6972D8),
          suffixIcon: Icon(Icons.public),
          hintText: "Search online...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
              bottom: Radius.circular(16),
            ),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (value) {
          searchProvider.searchFor().then((futureAlbums) {
            albumProvider.displayingAlbums = futureAlbums;
            searchProvider.isSearching = true;
            albumProvider.changeSelectedAlbum(null);
          });
        },
        onChanged: (value) {
          searchProvider.setQuerry(value);
        },
      ),
    );
  }
}
