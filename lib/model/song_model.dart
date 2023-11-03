import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SongModel {
  final String? id;
  final String title;
  final String description;
  final String url;
  final String coverUrl;
  final DateTime createdAt;
  final bool isFavorited;

  SongModel(
      {this.id,
      required this.title,
      required this.description,
      required this.url,
      required this.coverUrl,
      required this.createdAt,
      required this.isFavorited});

  toJson() {
    return {
      "Title": title,
      "Description": description,
      "Url": url,
      "CoverUrl": coverUrl,
      "CreatedAt": createdAt,
      "IsFavorited": isFavorited
    };
  }

  factory SongModel.fromSnapshot(QueryDocumentSnapshot<Object?> song) {
    return SongModel(
        id: song.id,
        title: song["Title"],
        description: song["Description"],
        url: song["Url"],
        coverUrl: song["CoverUrl"],
        isFavorited: song["IsFavorited"],
        createdAt: DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(song["CreatedAt"].toDate())));
  }
}
