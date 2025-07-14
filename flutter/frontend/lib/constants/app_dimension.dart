import 'package:flutter/material.dart';

class AppDimensions {
  static Size _size(BuildContext context) => MediaQuery.of(context).size;

  static double width(BuildContext context) => _size(context).width;
  static double height(BuildContext context) => _size(context).height;

  static double sideContainerWidth(BuildContext context) =>
      width(context) * 0.3;
  static double sideContainerHeight(BuildContext context) =>
      height(context) -
      bottomBarHeight(context) -
      appBarHeight(context); // You had an incomplete function

  static double infoPanelWidth(BuildContext context) => width(context) * 0.35;
  static double infoPanelHeight(BuildContext context) =>
      .8 * (height(context) - bottomBarHeight(context) - appBarHeight(context));

  static double albumListPanelWidth(BuildContext context) =>
      width(context) * 0.4;
  static double albumListPanelHeight(BuildContext context) =>
      height(context) - bottomBarHeight(context) - appBarHeight(context);

  static double albumCardWidth(BuildContext context) =>
      albumListPanelWidth(context) * 0.33;

  static double bottomBarHeight(BuildContext context) => height(context) * 0.05;
  static double appBarHeight(BuildContext context) => height(context) * 0.05;

  static Radius infoPanelBorderRadius = Radius.elliptical(10, 12);

  static double tracksPanelWidth(context) => infoPanelWidth(context) * 0.8;
  static double tracksPanelHeight(context) => infoPanelHeight(context) * .7;

  static double trackCardHeight() => 20;

  static double trackNumberPosition() => 0;
  static double trackTitlePosition() => 30;
  static double detailsButtonPosition(context) =>
      AppDimensions.tracksPanelWidth(context) - 40;
  static double trackTitleSpan() => 100;

  static WidgetStateProperty<Size> get detailsButtonMinSize =>
      WidgetStateProperty.all(Size(10, 10));
  static WidgetStateProperty<Size> get detailsButtonMaxSize =>
      WidgetStateProperty.all(Size(20, 20));
}
