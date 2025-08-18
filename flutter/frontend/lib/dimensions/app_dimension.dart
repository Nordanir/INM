import 'package:flutter/material.dart';

export 'info_panel_dimension.dart';

class AppDimensions {
  static Size _size(BuildContext context) => MediaQuery.of(context).size;

  static double width(BuildContext context) => _size(context).width;
  static double height(BuildContext context) => _size(context).height;


  static double sideContainerWidth(BuildContext context) =>
      width(context) * 0.3;
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
}
