import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:owlmap/application/user_controller.dart';
import 'package:owlmap/presentation/widgets/rounded_button.dart';
import 'package:quickalert/quickalert.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});
  static String id = 'user_profile_screen';

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late String name;
  late String email;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController _userController = UserController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 48.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 100.0,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _auth.currentUser?.photoURL != null
                              ? NetworkImage(_auth.currentUser!.photoURL!)
                              : AssetImage('assets/images/owl-100.png')
                                  as ImageProvider,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
            if (_auth.currentUser != null) ...[
              SizedBox(height: 24.0),
              // Editable Display Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _auth.currentUser!.displayName ?? '',
                      textAlign: TextAlign.center,
                      onChanged: (value) => name = value.trim(),
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter display name',
                      ),
                      onFieldSubmitted: (value) {
                        _focusNode.unfocus();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                _auth.currentUser!.email ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
              SizedBox(height: 24.0),
            ],
            RoundedButton(
              color: Colors.lightGreen,
              title: 'Save Changes',
              onPressed: () {
                try {
                  _userController.updateDisplayName(name);
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: 'Display name updated successfully!',
                    confirmBtnText: 'OK',
                  );
                  _focusNode.requestFocus();
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
