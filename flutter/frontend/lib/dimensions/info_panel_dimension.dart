import 'package:flutter/material.dart';

import 'app_dimension.dart';

class InfoPanelDimensions {
  //Info panel
  static double infoPanelWidth(BuildContext context) =>
      AppDimensions.width(context) * 0.28;
  static double infoPanelHeight(BuildContext context) =>
      AppDimensions.height(context) * .7;

  // Closing track info button
  static double closeTrackInfoButtonWidth(BuildContext context) =>
      infoPanelWidth(context) * .05;

  static double closeTrackInfoButtonHeight(BuildContext context) =>
      infoPanelWidth(context) * .05;

  // Track list

  static double trackListHeight(BuildContext context) =>
      infoPanelHeight(context) * .65;

  //Info panel content

  static double infoPanelContentWidth(BuildContext context) =>
      infoPanelWidth(context) * .9;
  static double infoPanelContentHeight(BuildContext context) =>
      infoPanelHeight(context) * .9;

  static double scrollableTitleWidth(BuildContext context) =>
      infoPanelContentWidth(context) * .65;

  static double entryButtonWidth(BuildContext context) =>
      InfoPanelDimensions.infoPanelWidth(context) * .075;
  static double entryButtonHeight(BuildContext context) =>
      InfoPanelDimensions.infoPanelWidth(context) * .075;

  static double ratingBoxWidth(BuildContext context) =>
      InfoPanelDimensions.infoPanelContentWidth(context) * .6;
  static double ratingBoxHeight(BuildContext context) =>
      InfoPanelDimensions.infoPanelContentHeight(context) * .15;

  static double trackInfoPanelIWitdth(BuildContext context) {
    return infoPanelWidth(context) * .85;
  }

  static double trackInfoCoverWidth(BuildContext context) {
    return infoPanelWidth(context) * .30;
  }
}
