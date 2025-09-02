import 'package:flutter/cupertino.dart';

import '../core/services/urls.dart';

class MediaModel {
  String id;
  String? name;
  String url;
  String thumb;
  String icon;
  String? size;

  static final String _defaultImage =
      "${imageBaseUrl}images/image_default.png";

  MediaModel({
    this.id = '',
    this.name,
    String? url,
    String? thumb,
    String? icon,
    this.size,
  })  : url = url ?? _defaultImage,
        thumb = thumb ?? _defaultImage,
        icon = icon ?? _defaultImage;

  factory MediaModel.fromJSON(Map<String, dynamic>? json) {
    try {
      if (json == null) return MediaModel();

      return MediaModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString(),
        url: json['url']?.toString(),
        thumb: json['thumb']?.toString(),
        icon: json['icon']?.toString(),
        size: json['formated_size']?.toString(),
      );
    } catch (e, s) {
      debugPrint("Media.fromJSON error: $e\n$s");
      return MediaModel();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "url": url,
      "thumb": thumb,
      "icon": icon,
      "formated_size": size,
    };
  }

  @override
  String toString() => toMap().toString();
}
