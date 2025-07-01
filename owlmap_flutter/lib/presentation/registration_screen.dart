import 'package:flutter/material.dart';
import 'package:owlmap/presentation/constants.dart';
import 'package:owlmap/presentation/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:owlmap/presentation/maps_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String email;
  late String password;
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
              Hero(
                tag: 'logo',
                flightShuttleBuilder: (
                  flightContext,
                  animation,
                  direction,
                  fromContext,
                  toContext,
                ) {
                  return RotationTransition(
                    turns: animation,
                    child: Image.asset(
                      'assets/images/owl-100.png',
                      height: 200,
                      width: 200,
                    ),
                  );
                },
                child: SizedBox(
                  height: 200.0,
                  width: 200.0,
                  child: Image.asset('assets/images/owl-100.png'),
                ),
              ),
              SizedBox(height: 48.0),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(height: 24.0),
              RoundedButton(
                color: Colors.blueAccent,
                title: 'Register',
                onPressed: () async {
                  setState(() {
                    _saving = true;
                  });
                  await _auth
                      .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      )
                      .then((userCredential) {
                        setState(() {
                          _saving = false;
                        });
                        Navigator.pushNamed(context, MapsScreen.id);
                      })
                      .catchError((error) {
                        setState(() {
                          _saving = false;
                        });
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Registration Failed',
                          text: error.toString(),
                          confirmBtnText: 'OK',
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
