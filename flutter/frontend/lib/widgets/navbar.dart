import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/superbase_config.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: AppDimensions.navBarDimensionsConstraints(context),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: lightGreen, width: 4),
              borderRadius: AppDimensions.navBarBorderRadius,
            ),
            child: Column(
              children: [
                Spacer(),
                NavBarButton(
                  onPressed: () {
                    Provider.of<SupabaseConfig>(
                      context,
                      listen: false,
                    ).retrieveAlbums(context);
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
    );
  }
}
