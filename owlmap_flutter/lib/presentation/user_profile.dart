import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:owlmap/application/image_capture_controller.dart';
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
  final ImageCaptureController _imageCaptureController =
      ImageCaptureController();
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 48.0),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
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
                  Positioned(
                    bottom: -10.0,
                    right: 110.0,
                    child: IconButton(
                      icon: Icon(Icons.add_a_photo, color: Colors.blueGrey),
                      onPressed: () async {
                        await _imageCaptureController.pickImageFromGallery().then(
                          (value) async {
                            setState(() {
                              _saving = true;
                            });
                            if (value != null) {
                              // final imageUrl = await _imageCaptureController
                              //     .saveProfileImage(
                              //       _auth.currentUser!.uid,
                              //       value,
                              //     );
                              // // Update the user's photoURL in Firebase Auth
                              // await _auth.currentUser!.updatePhotoURL(
                              //   imageUrl,
                              // );
                              // await _auth.currentUser!
                              //     .reload(); // Refresh user info
                              // QuickAlert.show(
                              //   context: context,
                              //   type: QuickAlertType.success,
                              //   text: 'Profile image updated successfully!',
                              //   confirmBtnText: 'OK',
                              // );
                              // setState(() {
                              //   _saving = false;
                              // }); // Rebuild to show new image
                            }
                          },
                        );
                        setState(() {});
                      },
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
                        // onFieldSubmitted: (value) {
                        //   _focusNode.unfocus();
                        // },
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
                onPressed: () async {
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
                  // setState(() {
                  //   name = _auth.currentUser?.displayName ?? '';
                  // });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
