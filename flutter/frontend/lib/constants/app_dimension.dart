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
}
