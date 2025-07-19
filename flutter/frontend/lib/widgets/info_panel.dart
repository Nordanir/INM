import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/superbase_config.dart';
import 'package:frontend/widgets/album_provider.dart';
import 'package:frontend/widgets/display_tracks.dart';
import 'package:frontend/widgets/search_provider.dart';
import 'package:frontend/widgets/util.dart';
import 'package:provider/provider.dart';

class InfoPanel extends StatelessWidget {
  final Album album;
  const InfoPanel({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    Track? selectedTrack = Provider.of<AlbumProvider>(context).selectedTrack;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Container(
        width: AppDimensions.infoPanelWidth(context) * .85,
        height: AppDimensions.infoPanelHeight(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(AppDimensions.infoPanelBorderRadius),
          border: Border.all(color: lightGreen),
          color: purle2,
        ),
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
    final searchProvider = Provider.of<SearchProvider>(context, listen: true);
    final supabaseConfig = Provider.of<SupabaseConfig>(context, listen: true);
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
        Expanded(
          child: (album.tracks.isNotEmpty)
              ? DisplayTracks(album: album)
              : DisplayText(text: "No tracks available"),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(color: Colors.red),
            width: AppDimensions.infoPanelWidth(context),
            height: 50,
            child: Row(
              children: [
                if (searchProvider.isSearching)
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<SupabaseConfig>(
                        context,
                        listen: false,
                      ).addAlbumToDatabase(album);
                    },
                    child: Text("Add to library"),
                  ),

                if (!searchProvider.isSearching)
                  ElevatedButton(
                    onPressed: () {
                      supabaseConfig.removeAlbumFromDatabase(album);
                    },
                    child: const Text("Remove from library"),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
