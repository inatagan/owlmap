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
}
