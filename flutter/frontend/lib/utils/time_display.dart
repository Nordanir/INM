String displayDuration(int miliseconds) {
  int seconds = miliseconds ~/ 1000;
  int mins = (seconds / 60).toInt();
  seconds -= mins * 60;
  int hours = (mins / 60).toInt();
  mins -= hours * 60;
  return [
    if (hours != 0) hours,
    mins,
    if (seconds < 10) "0$seconds" else seconds,
  ].join(':');
}

DateTime? fromStringToDate(String? date) {
  if (date != null) {
    List<dynamic> parts = date.split('-');
    parts = parts.map((value) => value.toInt()).toList();
    return DateTime(parts[0], parts[1], parts[2]);
  } else {
    return null;
  }
}
