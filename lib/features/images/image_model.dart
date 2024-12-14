import 'package:char_creator/common/interfaces/identifiable.dart';

class ImageModel extends Identifiable {
  final String filePath;

  const ImageModel({
    required super.id,
    required this.filePath,
  });

  factory ImageModel.fromFile({required String id, required String filePath}) {
    return ImageModel(
      id: id,
      filePath: filePath,
    );
  }
}
