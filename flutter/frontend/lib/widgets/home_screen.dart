import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/dimensions/content_list_dimensions.dart';
import 'package:frontend/superbase_config.dart';
import 'package:frontend/widgets/album_panel.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/auth.dart';
import 'package:frontend/widgets/info_panel.dart';
import 'package:frontend/widgets/search_bar.dart';
import 'package:frontend/widgets/tool_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SupabaseConfig>(
      builder: (context, supabaseConfig, child) {
        if (supabaseConfig.isUserLoggedIn == true) {
          return _BuildHomeScreen();
        } else {
          return AuthScreen();
        }
      },
    );
  }
}

class _BuildHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      albumProvider.albums = await Provider.of<SupabaseConfig>(
        context,
        listen: false,
      ).retrieveAlbums();
      for (Album album in albumProvider.albums) {
        album.calculateAlbumDuration();
      }

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
                width: ContentListDimesions.albumListPanelWidth(context),
                height: ContentListDimesions.albumListPanelHeight(context),
                child: Stack(
                  children: [
                    Container(
                      width: ContentListDimesions.albumListPanelWidth(context),
                      height: ContentListDimesions.albumListPanelHeight(
                        context,
                      ),
                      decoration: BoxDecoration(color: Color(0xff3166A8)),
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
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffCBDAEB),
                    border: Border(
                      left: BorderSide(width: 5, color: Color(0xff7092BE)),
                    ),
                  ),
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
      ],
    ),
  );
}
