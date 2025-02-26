import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../../common/interfaces/identifiable.dart';
import 'image_model.dart';

class ImageRepository {
  final Directory directory;
  final Uuid uuid = const Uuid();

  ImageRepository(this.directory);

  Future<ImageModel> saveImage(File imageFile) async {
    final String id = IdGenerator.generateId(ImageModel);
    final String fileExtension = path.extension(imageFile.path);
    final String newFileName = '$id$fileExtension';
    final String newFilePath = path.join(directory.path, newFileName);

    await imageFile.copy(newFilePath);

    return ImageModel(filePath: newFilePath);
  }

  Future<ImageModel> saveFromBytes(String filename, Uint8List bytes) async {
    final String filePath = path.join(directory.path, filename);

    await File(filePath).writeAsBytes(bytes);

    return ImageModel(filePath: filePath);
  }

  Future<ImageModel> getImageModelByPath(String providedPath) async {
    final List<FileSystemEntity> files = directory.listSync();

    for (var file in files) {
      if (file is File && file.path == providedPath) {
        return ImageModel(filePath: file.path);
      }
    }
    throw Exception('Image not found');
  }
}
