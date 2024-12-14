part of 'field_value.dart';

class ImageValue extends FieldValue {
  static const String typeId = 'image';

  final String url;

  ImageValue({
    required this.url,
  });

  factory ImageValue.fromJson(Map<String, dynamic> json) {
    return ImageValue(
      url: json['url'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': typeId,
      'url': url,
    };
  }
}
