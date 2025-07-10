import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/widgets/album_provider.dart';

class DisplayTracks extends StatelessWidget {
  final Album album;
  const DisplayTracks({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.infoPanelHeight(context) * .5,
      width: AppDimensions.infoPanelWidth(context) * .8,
      child: Container(
        decoration: BoxDecoration(),
        child: ListView.builder(
          itemCount: album.numberOfTracks,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, int index) {
            return TrackCard(track: album.tracks[index]);
          },
        ),
      ),
    );
  }
}

class TrackCard extends StatelessWidget {
  final Track track;
  const TrackCard({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Text(track.title);
  }
}
