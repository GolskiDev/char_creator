import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../../common/interfaces/identifiable.dart';
import 'image_model.dart';
import 'images_repostitory.dart';

class ImageUseCases {
  static Future<ImageModel> saveImageFromLocalDevice(
    ImageRepository repository,
    File imageFile,
  ) async {
    return await repository.saveImage(imageFile);
  }

  static Future<ImageModel> saveImageFromUrl(
    ImageRepository repository,
    String imageUrl,
  ) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final String id = IdGenerator.generateId(ImageModel);
      final String fileExtension = path.extension(imageUrl);
      final String newFileName = '$id$fileExtension';
      final String newFilePath =
          path.join(repository.directoryPath, newFileName);

      final File file = File(newFilePath);
      await file.writeAsBytes(response.bodyBytes);

      return ImageModel(id: id, filePath: newFilePath);
    } else {
      throw Exception('Failed to download image');
    }
  }
}
