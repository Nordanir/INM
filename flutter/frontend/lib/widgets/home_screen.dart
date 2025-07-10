import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/superbase_config.dart';
import 'package:frontend/widgets/album_panel.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/info_panel.dart';
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
          Row(
            children: [
              SizedBox(
                child: Container(
                  width: AppDimensions.sideContainerWidth(context),
                  height: AppDimensions.sideContainerHeight(context),
                  decoration: BoxDecoration(color: purle1),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: AppDimensions.albumListPanelWidth(context),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: AppDimensions.albumListPanelHeight(context),
                    ),
                    child: Container(
                      decoration: BoxDecoration(color: deepGreen),
                      child: DisplayAlbums(albumProvider: albumProvider),
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: Container(
                  width: AppDimensions.infoPanelWidth(context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      AppDimensions.infoPanelBorderRadius,
                    ),
                    border: Border.all(color: lightGreen),
                    color: purle2,
                  ),
                  height: AppDimensions.infoPanelHeight(context),
                  child: selectedAlbum != null
                      ? InfoPanel(album: selectedAlbum)
                      : null,
                ),
              ),
            ],
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
