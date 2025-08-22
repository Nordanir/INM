import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/dimensions/info_panel_dimension.dart';
import 'package:frontend/dimensions/tool_bar_dimension.dart';
import 'package:frontend/providers/album_provider.dart';
import 'package:frontend/providers/search_provider.dart';
import 'package:frontend/providers/selection_provider.dart';
import 'package:frontend/widgets/auth.dart';
import 'package:provider/provider.dart';

class SearchEntryOnline extends StatelessWidget {
  const SearchEntryOnline({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    return Container(
      height: ToolBarDimensions.toolBarHeight(context),
      width: InfoPanelDimensions.infoPanelWidth(context),
      alignment: Alignment.center,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: deepAccent,
          suffixIcon: MouseRegion(
            cursor: SystemMouseCursors.grabbing,
            child: IconButton(
              onPressed: () {
                searchProvider.resetOffSet();
                search(context);
              },
              icon: Icon(Icons.public),
            ),
          ),

          hintText: "Search online...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
              bottom: Radius.circular(16),
            ),
          ),
        ),
        onSubmitted: (value) {
          searchProvider.setQuerry(value);
          searchProvider.resetOffSet();
          search(context);
        },
        onChanged: (value) {
          searchProvider.setQuerry(value);
        },
      ),
    );
  }
}

Future<void> search(BuildContext context) async {
  final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
  final selectionProvider = Provider.of<SelectionProvider>(
    context,
    listen: false,
  );
  final searchProvider = Provider.of<SearchProvider>(context, listen: false);
  await Future.delayed(Duration(milliseconds: 500));

  showSnackBar(searching, context);
  final albums = await searchProvider.searchFor();

  if (albums.isEmpty) {
    showSnackBar(noSearchResult, context);
  }
  albumProvider.displayingAlbums = albums;
  searchProvider.isSearching = true;
  selectionProvider.changeSelectedAlbum(null);
}
