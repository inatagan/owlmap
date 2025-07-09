import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User loggedInUser;

  User getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return user;
      } else {
        throw Exception('No user is currently signed in.');
      }
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateDisplayName(String name) async {
    try {
      await _auth.currentUser!.updateProfile(displayName: name);
    } catch (e) {
      throw Exception('Failed to update display name');
    }
  }

  Future<void> updateImageProfile(String imageUrl) async {
    await _auth.currentUser!.updateProfile(photoURL: imageUrl);
  }
}
