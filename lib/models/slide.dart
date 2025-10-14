
import 'media.dart';

class SlidesModel {
  bool? success;
  List<Slides>? data;
  String? message;

  SlidesModel({this.success, this.data, this.message});

  SlidesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Slides>[];
      json['data'].forEach((v) {
        data!.add(new Slides.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Slides {
  int? id;
  int? order;
  String? text;
  String? button;
  String? textPosition;
  String? textColor;
  String? buttonColor;
  String? backgroundColor;
  String? indicatorColor;
  String? imageFit;
  Null? foodId;
  Null? restaurantId;
  bool? enabled;
  String? createdAt;
  String? updatedAt;
  List<Null>? customFields;
  bool? hasMedia;
  List<Media>? media;

  Slides(
      {this.id,
        this.order,
        this.text,
        this.button,
        this.textPosition,
        this.textColor,
        this.buttonColor,
        this.backgroundColor,
        this.indicatorColor,
        this.imageFit,
        this.foodId,
        this.restaurantId,
        this.enabled,
        this.createdAt,
        this.updatedAt,
        this.customFields,
        this.hasMedia,
        this.media});

  Slides.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    order = json['order'];
    text = json['text'];
    button = json['button'];
    textPosition = json['text_position'];
    textColor = json['text_color'];
    buttonColor = json['button_color'];
    backgroundColor = json['background_color'];
    indicatorColor = json['indicator_color'];
    imageFit = json['image_fit'];
    foodId = json['food_id'];
    restaurantId = json['restaurant_id'];
    enabled = json['enabled'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // if (json['custom_fields'] != null) {
    //   customFields = <Null>[];
    //   json['custom_fields'].forEach((v) {
    //     customFields!.add(new Null.fromJson(v));
    //   });
    // }
    hasMedia = json['has_media'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJSON(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order'] = order;
    data['text'] = text;
    data['button'] = button;
    data['text_position'] = textPosition;
    data['text_color'] = textColor;
    data['button_color'] = buttonColor;
    data['background_color'] = backgroundColor;
    data['indicator_color'] = indicatorColor;
    data['image_fit'] = imageFit;
    data['food_id'] = foodId;
    data['restaurant_id'] = restaurantId;
    data['enabled'] = enabled;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    // if (this.customFields != null) {
    //   data['custom_fields'] =
    //       this.customFields!.map((v) => v.toJson()).toList();
    // }
    data['has_media'] = hasMedia;
    if (media != null) {
      data['media'] = media!.map((v) => v.toMap()).toList();
    }
    return data;
  }
}

class CustomProperties {
  String? uuid;
  int? userId;
  GeneratedConversions? generatedConversions;

  CustomProperties({this.uuid, this.userId, this.generatedConversions});

  CustomProperties.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    userId = json['user_id'];
    generatedConversions = json['generated_conversions'] != null
        ? new GeneratedConversions.fromJson(json['generated_conversions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = uuid;
    data['user_id'] = userId;
    if (generatedConversions != null) {
      data['generated_conversions'] = generatedConversions!.toJson();
    }
    return data;
  }
}

class GeneratedConversions {
  bool? thumb;
  bool? icon;

  GeneratedConversions({this.thumb, this.icon});

  GeneratedConversions.fromJson(Map<String, dynamic> json) {
    thumb = json['thumb'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['thumb'] = thumb;
    data['icon'] = icon;
    return data;
  }
}

// class Slide extends Equatable {
//   final String id;
//   final int order;
//   final String text;
//   final String button;
//   final String textPosition;
//   final String textColor;
//   final String buttonColor;
//   final String backgroundColor;
//   final String indicatorColor;
//   final Media? image;
//   final String imageFit;
//   // final Food food;
//   // final Restaurant restaurant;
//   final bool enabled;
//
//   const Slide({
//     this.id = '',
//     this.order = 0,
//     this.text = '',
//     this.button = '',
//     this.textPosition = '',
//     this.textColor = '',
//     this.buttonColor = '',
//     this.backgroundColor = '',
//     this.indicatorColor = '',
//     this.image,
//     this.imageFit = 'cover',
//     // this.food = const Food(),
//     // this.restaurant = const Restaurant(),
//     this.enabled = false,
//   });
//
//   factory Slide.fromJson(Map<String, dynamic> json) {
//     try {
//       return Slide(
//         id: json['id']?.toString() ?? '',
//         order: json['order'] ?? 0,
//         text: json['text']?.toString() ?? '',
//         button: json['button']?.toString() ?? '',
//         textPosition: json['text_position']?.toString() ?? '',
//         textColor: json['text_color']?.toString() ?? '',
//         buttonColor: json['button_color']?.toString() ?? '',
//         backgroundColor: json['background_color']?.toString() ?? '',
//         indicatorColor: json['indicator_color']?.toString() ?? '',
//         imageFit: json['image_fit']?.toString() ?? 'cover',
//         enabled: json['enabled'] ?? false,
//         // restaurant: json['restaurant'] != null
//         //     ? Restaurant.fromJSON(json['restaurant'])
//         //     : const Restaurant(),
//         // food: json['food'] != null
//         //     ? Food.fromJSON(json['food'])
//         //     : const Food(),
//         image: (json['media'] is List && json['media'].isNotEmpty)
//             ? Media.fromJSON(json['media'][0])
//             : Media(),
//       );
//     } catch (e, stack) {
//       print(e);
//       return const Slide();
//     }
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       "id": id,
//       "text": text,
//       "order": order,
//       "button": button,
//       "text_position": textPosition,
//       "text_color": textColor,
//       "button_color": buttonColor,
//       "background_color": backgroundColor,
//       "indicator_color": indicatorColor,
//       "image_fit": imageFit,
//       "enabled": enabled,
//       // "restaurant": restaurant.toMap(),
//       // "food": food.toMap(),
//       "media": [image!.toMap()],
//     };
//   }
//
//   Slide copyWith({
//     String? id,
//     int? order,
//     String? text,
//     String? button,
//     String? textPosition,
//     String? textColor,
//     String? buttonColor,
//     String? backgroundColor,
//     String? indicatorColor,
//     Media? image,
//     String? imageFit,
//     // Food? food,
//     // Restaurant? restaurant,
//     bool? enabled,
//   }) {
//     return Slide(
//       id: id ?? this.id,
//       order: order ?? this.order,
//       text: text ?? this.text,
//       button: button ?? this.button,
//       textPosition: textPosition ?? this.textPosition,
//       textColor: textColor ?? this.textColor,
//       buttonColor: buttonColor ?? this.buttonColor,
//       backgroundColor: backgroundColor ?? this.backgroundColor,
//       indicatorColor: indicatorColor ?? this.indicatorColor,
//       image: image ?? this.image,
//       imageFit: imageFit ?? this.imageFit,
//       // food: food ?? this.food,
//       // restaurant: restaurant ?? this.restaurant,
//       enabled: enabled ?? this.enabled,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     id,
//     order,
//     text,
//     button,
//     textPosition,
//     textColor,
//     buttonColor,
//     backgroundColor,
//     indicatorColor,
//     image,
//     imageFit,
//     // food,
//     // restaurant,
//     enabled,
//   ];
// }
