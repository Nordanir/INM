import 'package:flutter/material.dart';
import 'package:frontend/classes/album.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/dimensions/content_list_dimensions.dart';
import 'package:frontend/providers/superbase_config.dart';
import 'package:frontend/widgets/album_panel.dart';
import 'package:frontend/providers/album_provider.dart';
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

class _BuildHomeScreen extends StatefulWidget {
  @override
  State<_BuildHomeScreen> createState() => _BuildHomeScreenState();
}

class _BuildHomeScreenState extends State<_BuildHomeScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  Future<void> _loadAlbums() async {
    try {
      final albumProvider = Provider.of<AlbumProvider>(context, listen: false);

      albumProvider.albums = await Provider.of<SupabaseConfig>(
        context,
        listen: false,
      ).retrieveAlbums();
      for (Album album in albumProvider.albums) {
        album.calculateAlbumDuration();
      }

      albumProvider.displayingAlbums = albumProvider.albums;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildMainContent(context),
    );
  }
}

Widget _buildMainContent(BuildContext context) {
  return SizedBox.expand(
    child: Column(
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: ContentListDimensions.albumListPanelWidth(context),
                height: ContentListDimensions.albumListPanelHeight(context),
                child: Container(
                  width: ContentListDimensions.albumListPanelWidth(context),
                  height: ContentListDimensions.albumListPanelHeight(context),
                  decoration: BoxDecoration(color: primaryBlue),
                  child: Column(
                    children: [
                      ToolBar(),
                      Expanded(child: DisplayAlbums()),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: lightBlueHighlight),
                  width: AppDimensions.sideContainerWidth(context),
                  child: Column(
                    children: [
                      SizedBox(
                        width: AppDimensions.sideContainerWidth(context),
                        child: SearchEntryOnline(),
                      ),
                      const SizedBox(height: 10),
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
