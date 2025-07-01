import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:owlmap/presentation/user_profile.dart';
import 'presentation/welcome_screen.dart';
import 'presentation/login_screen.dart';
import 'presentation/registration_screen.dart';
import 'presentation/maps_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // var permission = await Geolocator.checkPermission();
  // if (permission == LocationPermission.denied) {
  //   permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied) {
  //     return Future.error('Location permissions are denied');
  //   }
  // }

  runApp(const OwlMap());
}

class OwlMap extends StatelessWidget {
  const OwlMap({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        MapsScreen.id: (context) => MapsScreen(),
        UserProfileScreen.id: (context) => UserProfileScreen(),
      },
    );
  }
}
