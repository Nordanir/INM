import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/superbase_config.dart';
import 'package:frontend/widgets/album_panel.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/info_panel.dart';
import 'package:frontend/widgets/navbar.dart';
import 'package:frontend/widgets/search_bar.dart';
import 'package:frontend/widgets/tool_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      albumProvider.albums = await Provider.of<SupabaseConfig>(
        context,
        listen: false,
      ).retrieveAlbums();
      albumProvider.displayingAlbums = albumProvider.albums;
    });

    return Scaffold(body: _buildMainContent(context, albumProvider));
  }
}

Widget _buildMainContent(BuildContext context, AlbumProvider albumProvider) {
  return SizedBox.expand(
    child: Column(
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: AppDimensions.albumListPanelWidth(context),
                height: AppDimensions.albumListPanelHeight(context),
                child: Stack(
                  children: [
                    Container(
                      width: AppDimensions.albumListPanelWidth(context),
                      height: AppDimensions.albumListPanelHeight(context),
                      decoration: BoxDecoration(color: deepGreen),
                      child: Column(
                        children: [
                          SizedBox(
                            height: AppDimensions.toolBarHeight(context),
                            child: ToolBar(),
                          ),
                          Expanded(child: DisplayAlbums()),
                        ],
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(microseconds: 500),
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: NavBar(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: AppDimensions.sideContainerWidth(context),
                  child: Column(
                    children: [
                      SizedBox(
                        width: AppDimensions.sideContainerWidth(context),
                        child: SearchEntryOnline(),
                      ),
                      SizedBox(height: 10),
                      InfoPanel(),
                    ],
                  ),
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
