import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Pick image from camera
  Future<File?> pickImageFromCamera() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
