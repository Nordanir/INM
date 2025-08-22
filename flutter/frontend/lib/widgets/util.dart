import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/dimensions/info_panel_dimension.dart';

Duration durationFromSeconds(int seconds) {
  int secshehe = (seconds / 1000).toInt();
  int mins = (secshehe / 60).toInt();
  int fax = 60 * mins;
  int amacimasodpercei = secshehe - fax;

  return Duration(minutes: mins, seconds: amacimasodpercei);
}

String displayDuration(int durationInSeconds) {
  final duration = durationFromSeconds(durationInSeconds);
  final String hours = duration.inHours.toString();
  final String minutes = duration.inMinutes.toString();
  final String seconds = duration.inSeconds.remainder(60).toString();
  return [
    if (duration.inHours != 0) hours.toString(),
    minutes,
    seconds,
  ].join(':');
}

class ScrollableText extends StatefulWidget {
  const ScrollableText({
    super.key,
    required this.text,
    required this.areaWidth,
    required this.textSize,
    this.fontWeight = AppDimensions.normalWeight,
  });
  final String text;
  final double textSize;
  final double areaWidth;
  final FontWeight fontWeight;
  @override
  State<ScrollableText> createState() => _ScrollableTextState();
}

class _ScrollableTextState extends State<ScrollableText> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: SizedBox(
        width: InfoPanelDimensions.scrollableTitleWidth(context),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            widget.text,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: widget.fontWeight,
              color: black,
              fontSize: widget.textSize,
              fontFamily: "Inconsolata",
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
