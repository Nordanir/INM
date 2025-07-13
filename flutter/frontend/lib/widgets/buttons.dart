import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/widgets/album_provider.dart';

class DetailsButton extends StatelessWidget {
  const DetailsButton({super.key, required Track track});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: AppDimensions.detailsButtonMinSize,
        maximumSize: AppDimensions.detailsButtonMaxSize,
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      onPressed: () {},
      child: Icon(Icons.arrow_forward),
    );
  }
}
