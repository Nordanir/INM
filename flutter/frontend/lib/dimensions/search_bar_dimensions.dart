import 'package:flutter/widgets.dart';
import 'package:frontend/dimensions/info_panel_dimension.dart';
import 'package:frontend/dimensions/tool_bar_dimension.dart';

class SearchBarDimensions {
  static double changeCategoryButtonWidth(BuildContext context) {
    return InfoPanelDimensions.infoPanelWidth(context) * .2;
  }

  static double widgetHeight(BuildContext context) =>
      ToolBarDimensions.toolBarHeight(context) / 1.7;

  static BorderRadius popUpMenuBorderRadius = BorderRadius.horizontal(
    left: Radius.circular(32),
    right: Radius.circular(13),
  );

  static BorderRadius widgetBorderRadius = BorderRadius.vertical(
    top: Radius.circular(16),
    bottom: Radius.circular(16),
  );
}
