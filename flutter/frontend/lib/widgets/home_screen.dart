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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SupabaseConfig>(
        context,
        listen: false,
      ).retrieveAlbums(context);
    });

    return Scaffold(
      body: Consumer<AlbumProvider>(
        builder: (context, albumProvider, _) {
          if (albumProvider.albums.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return _buildMainContent(context, albumProvider);
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, AlbumProvider albumProvider) {
    final selectedAlbum = Provider.of<AlbumProvider>(context).selectedAlbum;
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
                            Provider.of<SearchProvider>(
                              context,
                              listen: false,
                            ).searchFor().then((futureAlbums) {
                              Provider.of<AlbumProvider>(
                                context,
                                listen: false,
                              ).albums = futureAlbums;
                            });
                          },
                          onChanged: (value) {
                            Provider.of<SearchProvider>(
                              context,
                              listen: false,
                            ).setQuerry(value);
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      if (selectedAlbum != null)
                        InfoPanel(album: selectedAlbum),
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
