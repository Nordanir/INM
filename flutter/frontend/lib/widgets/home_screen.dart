import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/superbase_config.dart';
import 'package:frontend/widgets/album_panel.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/info_panel.dart';
import 'package:frontend/widgets/navbar.dart';
import 'package:frontend/widgets/search_provider.dart';
import 'package:provider/provider.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AlbumProvider>(
        context,
        listen: false,
      ).albums = await Provider.of<SupabaseConfig>(
        context,
        listen: false,
      ).retrieveAlbums();
    });

    return Scaffold(
      body: Consumer<AlbumProvider>(
        builder: (context, albumProvider, _) {
          return _buildMainContent(context, albumProvider);
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, AlbumProvider albumProvider) {
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    return SizedBox.expand(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: AppDimensions.sideContainerWidth(context),
                  height: AppDimensions.sideContainerHeight(context),
                  decoration: BoxDecoration(color: purle1),
                  child: NavBar(),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: deepGreen),
                    child: DisplayAlbums(albumProvider: albumProvider),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      SizedBox(
                        width: AppDimensions.sideContainerWidth(context),
                        child: SearchBar(
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
                        ),
                      ),
                      SizedBox(height: 10),
                      if (albumProvider.selectedAlbum != null)
                        InfoPanel(album: albumProvider.selectedAlbum!),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: olive),
            width: AppDimensions.width(context),
            height: AppDimensions.bottomBarHeight(context),
            child: Text("data"),
          ),
        ],
      ),
    );
  }
}
