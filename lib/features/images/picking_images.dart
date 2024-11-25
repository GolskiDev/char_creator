import 'package:image_picker/image_picker.dart';

class PickingImages {
  static Future<void> pickImage() async {
    ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      print('Image path: ${image.path}');
    } else {
      print('No image selected.');
    }
  }
}
