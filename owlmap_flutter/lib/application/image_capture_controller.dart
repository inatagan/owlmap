// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:owlmap/application/user_controller.dart';
import 'package:owlmap/data/media_repository.dart';

final ImagePicker _picker = ImagePicker();
final MediaRepository _mediaRepository = MediaRepository();

class ImageCaptureController {
  Future<String> pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50, // Adjust quality as needed
      );
      if (pickedFile != null) {
        // Handle the selected image file
        print('Image selected: ${pickedFile.path}');
        return pickedFile.toString();
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
    throw Exception('No image selected or error occurred.');
  }

  Future<String> saveProfileImage(String userId, String filePath) async {
    final imageUrl = await _mediaRepository
        .updateUserProfileImage(userId, filePath)
        .catchError((error) {
          print('Error saving profile image: $error');
          throw Exception('Failed to save profile image: $error');
        });
    return imageUrl;
  }

  // Future<void> cropImage() async {
  //   File croppedFile = await ImageCropper().cropImage(
  //     sourcePath: pickedFile.path,
  //     aspectRatioPresets: [
  //       CropAspectRatioPreset.square,
  //       CropAspectRatioPreset.original,
  //     ],
  //     androidUiSettings: AndroidUiSettings(
  //       toolbarTitle: 'Cropper',
  //       toolbarColor: Colors.deepOrange,
  //       toolbarWidgetColor: Colors.white,
  //       initAspectRatio: CropAspectRatioPreset.original,
  //       lockAspectRatio: false,
  //     ),
  //     iosUiSettings: IOSUiSettings(
  //       minimumAspectRatio: 1.0,
  //     ),
  //   );
  // }
}
