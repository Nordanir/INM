import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/providers/album_provider.dart';
import 'package:frontend/providers/search_provider.dart';
import 'package:frontend/providers/selection_provider.dart';
import 'package:provider/provider.dart';

class SearchEntryOnline extends StatelessWidget {
  const SearchEntryOnline({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    final albumProvider = Provider.of<AlbumProvider>(context);
    final selectionProvider = Provider.of<SelectionProvider>(context);
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: AppDimensions.sideContainerHeight(context) * .1,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: deepBlueHighLight,
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
        onSubmitted: (value) async {
          if (value.isEmpty) return;

          final albums = await searchProvider.searchFor();
          albumProvider.displayingAlbums = albums;
          searchProvider.isSearching = true;
          selectionProvider.changeSelectedAlbum(null);
        },
        onChanged: (value) {
          searchProvider.setQuerry(value);
        },
      ),
    );
  }
}
