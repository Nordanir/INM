import 'dart:ui';

import 'package:frontend/classes/album.dart';
import 'package:frontend/classes/entity.dart';
import 'package:frontend/utils/time_display.dart';

class Artist extends Entity {
  final List<Album> albums = [];
  Image? coverImage;
  final bool? isActive;
  final String? area;
  final String? country;
  final DateTime? beginDate;
  final DateTime? endDate;

  Artist({
    required super.id,
    required super.title,
    required this.isActive,
    this.area,
    this.country,
    this.beginDate,
    this.endDate,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json["id"],
      title: json['name'],
      isActive: json['ended'],
      area: json['area'] != null ? json['area']['name'] : null,
      country: json['country'],
      beginDate: fromStringToDate(json['begin']),
      endDate: fromStringToDate(json['end']),
    );
  }

  
}
