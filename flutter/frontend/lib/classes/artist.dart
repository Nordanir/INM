import 'package:frontend/classes/album.dart';
import 'package:frontend/classes/entity.dart';
import 'package:frontend/utils/time_display.dart';

class Artist extends Entity {
  final List<Album> albums = [];
  final bool? isActive;
  final String? area;
  final String? country;
  final DateTime? activeFrom;
  final DateTime? activeUntil;

  Artist({
    required super.id,
    required super.title,
    required this.isActive,
    this.area,
    this.country,
    this.activeFrom,
    this.activeUntil,
  });

  

  // OBSOLETE : must be rewritten to fit the new scheme

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json["id"],
      title: json['name'],
      isActive: json['ended'],
      area: json['area'] != null ? json['area']['name'] : null,
      country: json['country'],
      activeFrom: fromStringToDate(json['begin']),
      activeUntil: fromStringToDate(json['end']),
    );
  }

  
}
