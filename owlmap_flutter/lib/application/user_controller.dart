import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User loggedInUser;

  User getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // print('User is signed in: ${user.email}');
        return user;
      } else {
        throw Exception('No user is currently signed in.');
      }
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  void updateDisplayName(String name) {
    try {
      loggedInUser = _auth.currentUser!;
      loggedInUser.updateProfile(displayName: name);
      loggedInUser.reload();
      loggedInUser = _auth.currentUser!;
    } catch (e) {
      print('Error updating display name: $e');
      throw Exception('Failed to update display name');
    }
  }
}
