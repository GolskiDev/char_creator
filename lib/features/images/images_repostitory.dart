import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../../common/interfaces/identifiable.dart';
import 'image_model.dart';

class ImageRepository {
  final String directoryPath;
  final Uuid uuid = Uuid();

  ImageRepository(this.directoryPath);

  Future<ImageModel> saveImage(File imageFile) async {
    final String id = IdGenerator.generateId(ImageModel);
    final String fileExtension = path.extension(imageFile.path);
    final String newFileName = '$id$fileExtension';
    final String newFilePath = path.join(directoryPath, newFileName);

    await imageFile.copy(newFilePath);

    return ImageModel(id: id, filePath: newFilePath);
  }

  Future<File?> getImageById(String id) async {
    final Directory directory = Directory(directoryPath);
    final List<FileSystemEntity> files = directory.listSync();

    for (var file in files) {
      if (file is File && path.basenameWithoutExtension(file.path) == id) {
        return file;
      }
    }
    return null;
  }
}
