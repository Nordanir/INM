import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/info_panel.dart';

class DisplayTracks extends StatelessWidget {
  final Album album;
  const DisplayTracks({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.trackBarHeight(context),
      width: AppDimensions.trackBarWidth(context),
      child: Container(
        decoration: BoxDecoration(),
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 16),
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
    return SizedBox(
      height: AppDimensions.trackCardHeight(),
      width: AppDimensions.trackBarWidth(context),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: DisplayText(text: track.numberOnTheAlbum.toString()),
          ),
          Positioned(
            left: AppDimensions.trackTitlePosition(),
            right: AppDimensions.trackTitleSpan(),
            child: DisplayText(text: track.title),
          ),
          Positioned(
            left: AppDimensions.detailsButtonPosition(context),
            child: DetailsButton(track: track),
          ),
        ],
      ),
    );
  }
}
