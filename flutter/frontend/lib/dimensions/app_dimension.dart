import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

export 'info_panel_dimension.dart';

class AppDimensions {
  static Size _size(BuildContext context) => MediaQuery.of(context).size;

  static double width(BuildContext context) => _size(context).width;
  static double height(BuildContext context) => _size(context).height;

  static double sideContainerWidth(BuildContext context) =>
      width(context) * 0.28;
  static double sideContainerHeight(BuildContext context) =>
      height(context) - bottomBarHeight(context) - appBarHeight(context);

  static double bottomBarHeight(BuildContext context) => height(context) * 0.05;
  static double appBarHeight(BuildContext context) => height(context) * 0.05;

  static Radius infoPanelBorderRadius = Radius.elliptical(10, 12);

  static double trackCardHeight() => 46;

  static double trackNumberPosition() => 0;
  static double trackTitlePosition() => 50;
  static double trackTitleSpan() => 100;

  static WidgetStateProperty<Size> get detailsButtonMinSize =>
      WidgetStateProperty.all(Size(10, 10));
  static WidgetStateProperty<Size> get detailsButtonMaxSize =>
      WidgetStateProperty.all(Size(20, 20));

  static BorderRadiusGeometry navBarBorderRadius = BorderRadius.vertical(
    top: Radius.elliptical(20, 20),
    bottom: Radius.elliptical(20, 20),
  );

  static BoxConstraints navBarDimensionsConstraints(BuildContext context) =>
      BoxConstraints(
        minWidth: AppDimensions.sideContainerWidth(context) * .25,
        maxWidth: AppDimensions.sideContainerWidth(context) * .4,
        minHeight: AppDimensions.sideContainerHeight(context) * .35,
        maxHeight: AppDimensions.sideContainerHeight(context) * .5,
      );

  static Size minWindowSize() => Size(1550, 850);

  static const double smallFontSize = 8;
  static const double normalFontSize = 16;
  static const double emphasizedFontSize = 24;

  static double normalFontWeight = 1;
  static double emphasizedFontWeight = 1;

  static EdgeInsets smallPadding = EdgeInsets.all(8);
  static EdgeInsets normalPadding = EdgeInsets.all(16);
  static EdgeInsets largePadding(BuildContext context) {
    return width(context) < 1700 ? EdgeInsets.all(20) : EdgeInsets.all(24);
  }

  static double smallSpacing = 8;
  static double normalSpacing(BuildContext context) {
    return width(context) < 1700 ? 12 : 16;
  }

  static double largeSpacing(BuildContext context) {
    return width(context) < 1700 ? 20 : 24;
  }

  static double outlineWidth = 1;
  static double narrowBorderWidth = 4;
  static double wideBorderWidth = 8;

  static const FontWeight normalWeight = FontWeight.w600;
  static const FontWeight emphasizedWeight = FontWeight.w900;

  static BoxShadow containershadow = BoxShadow(
    color: deepBlueHighLight.withValues(alpha: 0.5),
    spreadRadius: 5,
    blurRadius: 1,
    offset: Offset(-2, 2), // changes position of shadow
  );
}
