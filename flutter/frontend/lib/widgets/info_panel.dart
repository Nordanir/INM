import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/display_tracks.dart';
import 'package:frontend/widgets/util.dart';
import 'package:provider/provider.dart';

class InfoPanel extends StatelessWidget {
  final Album album;
  const InfoPanel({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    Track? selectedTrack = Provider.of<AlbumProvider>(context).selectedTrack;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(),
        child: (selectedTrack == null)
            ? TrackList(album: album)
            : TrackInfo(track: selectedTrack),
      ),
    );
  }
}

class DisplayText extends StatelessWidget {
  const DisplayText({
    super.key,
    required this.text,
    this.label,
    this.align = TextAlign.left,
  });
  final String text;
  final String? label;
  final TextAlign align;
  @override
  Widget build(BuildContext context) {
    return Text(
      label != null ? "$label  $text" : text,
      textAlign: TextAlign.left,
      style: TextStyle(color: lightGreen),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

class TrackList extends StatelessWidget {
  const TrackList({super.key, required this.album});
  final Album album;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DisplayText(
          text: album.title,
          label: albumTitle,
          align: TextAlign.center,
        ),
        DisplayText(
          label: duration,
          text: displayDuration(timeFromSeconds(album.duration)),
          align: TextAlign.center,
        ),
        DisplayText(
          label: numOfTracks,
          text: album.numberOfTracks.toString(),
          align: TextAlign.center,
        ),
        const SizedBox(height: 20),
        (album.tracks.isNotEmpty)
            ? DisplayTracks(album: album)
            : DisplayText(text: "No tracks available"),
      ],
    );
  }
}
