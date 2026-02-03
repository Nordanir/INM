import 'package:flutter/material.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/themes/text_theme.dart';

class ScrollableText extends StatefulWidget {
  const ScrollableText({
    super.key,
    required this.text,
    required this.textStyle,
    this.textAlign = TextAlign.left,
  });
  final TextAlign? textAlign;
  final TextStyle textStyle;
  final String text;
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
            style: widget.textStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class DisplayText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final TextStyle? textStyle;
  final int? maxLines;

  const DisplayText({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.letterSpacing,
    this.maxLines,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle ?? defaultTextStyle,
      textAlign: textAlign,
      maxLines: maxLines ?? 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
