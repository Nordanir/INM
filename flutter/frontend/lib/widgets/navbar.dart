import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/superbase_config.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/search_provider.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseConfig = Provider.of<SupabaseConfig>(context, listen: false);
    final albumProvider = Provider.of<AlbumProvider>(context, listen: true);
    final searchProvider = Provider.of<SearchProvider>(context, listen: true);
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      child: Center(
        child: ConstrainedBox(
          constraints: AppDimensions.navBarDimensionsConstraints(context),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              decoration: BoxDecoration(
                color: purle1.withValues(alpha: .7),
                border: Border.all(color: lightGreen, width: 4),
                borderRadius: AppDimensions.navBarBorderRadius,
              ),
              child: Column(
                children: [
                  Spacer(),
                  NavBarButton(
                    onPressed: () async {
                      albumProvider.albums = await supabaseConfig
                          .retrieveAlbums();
                      searchProvider.isSearching = false;
                      albumProvider.changeSelectedAlbum(null);
                    },
                    icon: Icons.home,
                  ),
                  Spacer(),
                  NavBarButton(onPressed: () {}, icon: Icons.search),
                  Spacer(),
                  NavBarButton(onPressed: () {}, icon: Icons.settings),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
