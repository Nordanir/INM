import 'package:flutter/material.dart';
import 'package:frontend/classes/album.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/dimensions/content_list_dimensions.dart';
import 'package:frontend/providers/search_provider.dart';
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
    final supabaseConfig = Provider.of<SupabaseConfig>(context, listen: false);

    return FutureBuilder<bool>(
      future: supabaseConfig.isKeptLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Consumer<SupabaseConfig>(
            builder: (context, supabaseConfig, child) {
              if (supabaseConfig.isUserLoggedIn == true) {
                return _BuildHomeScreen();
              } else {
                return const AuthScreen();
              }
            },
          );
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
  final searchProvider = Provider.of<SearchProvider>(context);
  return Container(
    padding: AppDimensions.largePadding(context),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [primaryBlue, deepBlueHighLight.withValues(alpha: .85)],
      ),
    ),
    width: AppDimensions.width(context),
    height: AppDimensions.height(context),
    child: Row(
      children: [
        Column(
          children: [
            Expanded(
              child: SizedBox(
                width: ContentListDimensions.albumListPanelWidth(context),
                height: ContentListDimensions.albumListPanelHeight(context),
                child: Stack(
                  children: [
                    SizedBox(
                      width: ContentListDimensions.albumListPanelWidth(context),
                      height: ContentListDimensions.albumListPanelHeight(
                        context,
                      ),
                      child: Column(
                        children: [
                          ToolBar(),
                          SizedBox(height: AppDimensions.largeSpacing(context)),
                          Expanded(child: DisplayAlbums()),
                        ],
                      ),
                    ),
                    if (searchProvider.isSearching &&
                        searchProvider.offSet != 0)
                      Positioned(
                        top: ContentListDimensions.pageButtonTopPosition(
                          context,
                        ),
                        right: ContentListDimensions.pageButtonLeftPosition(
                          context,
                        ),
                        child: PageButton(fowardOrBack: false),
                      ),
                    if (searchProvider.isSearching)
                      Positioned(
                        top: ContentListDimensions.pageButtonTopPosition(
                          context,
                        ),

                        left: ContentListDimensions.pageButtonLeftPosition(
                          context,
                        ),

                        child: PageButton(fowardOrBack: true),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: double.infinity,
          width: AppDimensions.normalSpacing(context),
        ),
        SizedBox(
          height: AppDimensions.height(context),
          width: AppDimensions.sideContainerWidth(context),
          child: Column(
            children: [
              SizedBox(
                width: AppDimensions.sideContainerWidth(context),
                child: SearchEntryOnline(),
              ),
              SizedBox(height: AppDimensions.largeSpacing(context)),
              InfoPanel(),
            ],
          ),
        ),
      ],
    ),
  );
}

class PageButton extends StatelessWidget {
  PageButton({super.key, required this.fowardOrBack});
  bool fowardOrBack;
  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    return IconButton(
      style: ElevatedButton.styleFrom(backgroundColor: accent),
      onPressed: () {
        if (fowardOrBack) {
          searchProvider.nextPage();

          search(context);
        }
      },
      icon: Icon(
        size: 30,
        fowardOrBack ? Icons.arrow_forward : Icons.arrow_back,
      ),
    );
  }
}
