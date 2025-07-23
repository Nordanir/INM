import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/widgets/album_provider.dart';

class DetailsButton extends StatelessWidget {
  const DetailsButton({
    super.key,
    required Track track,
    required this.onPressed,
  });
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: AppDimensions.detailsButtonMinSize,
        maximumSize: AppDimensions.detailsButtonMaxSize,
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      onPressed: onPressed,
      child: Icon(Icons.arrow_forward),
    );
  }
}

class NavBarButton extends StatelessWidget {
  const NavBarButton({super.key, required this.onPressed, required this.icon});
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        minimumSize: AppDimensions.navBarButtonMinSize,
        maximumSize: AppDimensions.navBarButtonMaxSize,
        backgroundColor: lightGreen,
        alignment: Alignment.center
      ),

      onPressed: onPressed,
      child: Icon(size: AppDimensions.navBarButtonIconSize(), icon),
    );
  }
}
