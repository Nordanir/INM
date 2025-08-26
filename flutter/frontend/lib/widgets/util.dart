import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/dimensions/app_dimension.dart';

String displayDuration(int miliseconds) {
  int seconds = miliseconds ~/ 1000;
  int mins = (seconds / 60).toInt();
  seconds -= mins * 60;
  int hours = (mins / 60).toInt();
  mins -= hours * 60;
  return [if (hours != 0) hours, mins, seconds].join(':');
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
