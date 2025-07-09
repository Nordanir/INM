import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/util.dart';

class InfoPanel extends StatelessWidget {
  final Album album;
  const InfoPanel({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        children: [
          DisplayText(text: album.title, label: albumTitle),
          DisplayText(
            label: duration,
            text: displayDuration(timeFromSeconds(album.duration)),
          ),
          DisplayText(
            label: numOfTracks,
            text: album.numberOfTracks.toString(),
          ),
        ],
      ),
    );
  }
}

class DisplayText extends StatelessWidget {
  const DisplayText({super.key, required this.text, this.label});
  final String text;
  final String? label;
  @override
  Widget build(BuildContext context) {
    return Text(
      label != null ? "$label  $text" : text,
      textAlign: TextAlign.center,
      style: TextStyle(color: lightGreen),
    );
  }
}
