import 'package:flutter/material.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/dimensions/content_list_dimensions.dart';

class ToolBarDimensions {
  static double toolBarWidth(BuildContext context) {
    return ContentListDimensions.albumListPanelWidth(context);
  }

  static double toolBarHeight(BuildContext context) =>
      AppDimensions.height(context) * .080;

  static Size get navBarButtonMinSize => Size(60, 60);
  static Size get navBarButtonMaxSize => Size(120, 120);
  static double navBarButtonIconSize() => 20;

  static double toolBarSearchBarHeight(BuildContext context) {
    return toolBarHeight(context) * .6;
  }

  static BorderRadius toolBarBorderRadius() {
    return BorderRadius.vertical(
      top: Radius.circular(16),
      bottom: Radius.circular(16),
    );
  }
}
