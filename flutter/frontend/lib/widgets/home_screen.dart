import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/superbase_config.dart';
import 'package:frontend/widgets/album_panel.dart';
import 'package:frontend/widgets/album_provider.dart';
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
    return SizedBox.expand(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                child: Container(
                  color: const Color.fromRGBO(11, 206, 40, 1),
                  width: AppDimensions.sideContainerWidth(context),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: AppDimensions.albumListPanelWidth(context),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: AppDimensions.albumListPanelHeight(context),
                    ),
                    child: DisplayAlbums(albumProvider: albumProvider),
                  ),
                ),
              ),
              SizedBox(
                child: Container(
                  color: const Color.fromRGBO(209, 222, 19, 1),
                  width: AppDimensions.sideContainerWidth(context),
                ),
              ),
            ],
          ),
          Container(
            color: const Color.fromRGBO(200, 57, 6, 1),
            width: double.infinity,
            height: AppDimensions.bottomBarHeight(context),
          ),
        ],
      ),
    );
  }
}
