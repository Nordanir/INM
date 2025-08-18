import 'package:flutter/material.dart';
import 'package:frontend/dimensions/app_dimension.dart';

class ToolBarDimensions {
  static double toolBarHeight(BuildContext context) =>
      AppDimensions.height(context) * .080;

  static Size get navBarButtonMinSize => Size(60, 60);
  static Size get navBarButtonMaxSize => Size(120, 120);
  static double navBarButtonIconSize() => 20;
}
