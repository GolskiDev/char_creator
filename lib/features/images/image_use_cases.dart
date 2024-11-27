import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../common/interfaces/identifiable.dart';
import 'image_model.dart';
import 'images_repostitory.dart';

class ImageUseCases {
  static Future<ImageModel> pickFromLocalDeviceAndSave(
    ImageRepository repository,
  ) async {
    ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      throw Exception('No image selected');
    }

    return await repository.saveImage(
      File(image.path),
    );
  }

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

      return repository.saveFromBytes(newFileName, response.bodyBytes);
    } else {
      throw Exception('Failed to download image');
    }
  }
}
