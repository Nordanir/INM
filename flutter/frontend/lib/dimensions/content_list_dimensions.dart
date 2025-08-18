import 'package:flutter/widgets.dart';
import 'package:frontend/dimensions/app_dimension.dart';

class ContentListDimensions {
  static double albumListPanelWidth(BuildContext context) =>
      AppDimensions.width(context) * 0.68;
  static double albumListPanelHeight(BuildContext context) =>
      AppDimensions.height(context);

  static double albumCardWidth(BuildContext context) =>
      albumListPanelWidth(context) * 0.15;

  static BorderRadius albumCardBorderRadius() {
    return BorderRadius.vertical(
      top: Radius.circular(16),
      bottom: Radius.circular(16),
    );
  }

  static double albumCardPictureWidth(BuildContext context) =>
      albumCardWidth(context) * .7;
  static double albumCardTextBoxWidth(BuildContext context) =>
      albumCardWidth(context) * .8;
}
