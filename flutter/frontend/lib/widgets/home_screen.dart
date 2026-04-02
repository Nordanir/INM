import 'package:flutter/material.dart';
import 'package:frontend/classes/entity.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/dimensions/content_list_dimensions.dart';
import 'package:frontend/providers/display_provider.dart';
import 'package:frontend/providers/pocket_base_config.dart';
import 'package:frontend/providers/search_provider.dart';
import 'package:frontend/widgets/album_panel.dart';
import 'package:frontend/widgets/auth.dart';
import 'package:frontend/widgets/info_panel.dart';
import 'package:frontend/widgets/search_bar.dart';
import 'package:frontend/widgets/tool_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});



  @override
  Widget build(BuildContext context) {

     return ValueListenableBuilder<bool?>(
      valueListenable: PocketBaseConfig.isLoggedInNotifier,
      builder: (context, isLoggedIn, _) {
        if (isLoggedIn == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        return isLoggedIn ? _BuildHomeScreen() : AuthScreen();
      },
    );
  }
}

class _BuildHomeScreen extends StatefulWidget {
  @override
  State<_BuildHomeScreen> createState() => _BuildHomeScreenState();
}

class _BuildHomeScreenState extends State<_BuildHomeScreen> {

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  Future<void> _loadAlbums() async {
    await context.read<DisplayProvider>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    final displayProvider = context.watch<DisplayProvider>();
    if (displayProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      body: _buildMainContent(context),
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
  const PageButton({super.key, required this.fowardOrBack});
  final bool fowardOrBack;
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
