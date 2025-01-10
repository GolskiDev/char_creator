import 'package:char_creator/common/interfaces/identifiable.dart';

class ImageModel extends Identifiable {
  final String filePath;
  @override
  get id => filePath;

  const ImageModel({
    required this.filePath,
  });

  factory ImageModel.fromFile({required String id, required String filePath}) {
    return ImageModel(
      filePath: filePath,
    );
  }
}
