import 'package:flutter/material.dart';

void displayMessage(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 2),
}) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message), duration: duration));
}

Duration timeFromSeconds(int seconds) {
  final secshehe = seconds;
  int mins = (secshehe / 60).toInt();
  int fax = 60 * mins;
  int amacimasodpercei = secshehe - fax;

  return Duration(minutes: mins, seconds: amacimasodpercei);
}

String displayDuration(Duration duration) {
  final String hours = duration.inHours.toString();
  final String minutes = duration.inMinutes.toString();
  final String seconds = duration.inSeconds.remainder(60).toString();
  return [
    if (duration.inHours != 0) hours.toString(),
    minutes,
    seconds,
  ].join(':');
}
