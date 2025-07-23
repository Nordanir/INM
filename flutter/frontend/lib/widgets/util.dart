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
