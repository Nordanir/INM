import 'package:flutter/widgets.dart';
import 'package:frontend/constants/app_dimension.dart';

class ContentListDimesions {
  static double albumListPanelWidth(BuildContext context) =>
      AppDimensions.width(context) * 0.68;
  static double albumListPanelHeight(BuildContext context) =>
      AppDimensions.height(context);

  static double albumCardWidth(BuildContext context) =>
      albumListPanelWidth(context) * 0.15;

  static double albumCardPictureWidth(BuildContext context) =>
      albumCardWidth(context) * .7;
  static double albumCardTextBoxWidth(BuildContext context) =>
      albumCardWidth(context) * .8;
}
