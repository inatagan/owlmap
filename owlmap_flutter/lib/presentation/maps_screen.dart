import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:owlmap/application/geolocator_controller.dart';
import 'package:owlmap/application/user_controller.dart';
import 'package:owlmap/presentation/welcome_screen.dart';
import 'package:owlmap/application/markers_controller.dart';
import 'package:quickalert/quickalert.dart';

final appKey = GlobalKey();

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});
  static String id = 'maps_screen';

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MarkersController _markersController = MarkersController();
  final UserController _userController = UserController();
  final GeolocatorController _geolocatorController = GeolocatorController();
  late User loggedInUser;
  late Set<Marker> _markers = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    loggedInUser = _userController.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('OwlMap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushNamed(context, WelcomeScreen.id);
            },
          ),
        ],
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        myLocationEnabled: true,
        compassEnabled: true,
        onMapCreated: _markersController.onMapCreated,
        markers: _markers,
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.add_location),
              tooltip: 'Save Location',
              onPressed: () async {
                String title = '';
                String snippet = '';
                await QuickAlert.show(
                  context: context,
                  type: QuickAlertType.custom,
                  barrierDismissible: true,
                  confirmBtnText: 'Save',
                  customAsset: 'assets/images/owl-100.png',
                  widget: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintText: 'Enter Title',
                          prefixIcon: Icon(Icons.title_outlined),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onChanged: (value) => title = value,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintText: 'Enter Note',
                          prefixIcon: Icon(Icons.message_outlined),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onChanged: (value) => snippet = value,
                      ),
                    ],
                  ),
                  onConfirmBtnTap: () async {
                    if (title.length < 2) {
                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'Please input something',
                      );
                      return;
                    } else if (snippet.length < 2) {
                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'Please input something',
                      );
                      return;
                    } else {
                      final position =
                          await _geolocatorController.determinePosition();
                      _markersController.saveMarker(
                        position.latitude,
                        position.longitude,
                        loggedInUser.uid,
                        title,
                        snippet,
                      );
                    }
                    Navigator.pop(context);
                    await Future.delayed(const Duration(milliseconds: 1000));
                    await QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: "Phone number '$title' has been saved!.",
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.location_history),
              tooltip: 'Load Saved Locations',
              onPressed: () async {
                _markers = await _markersController.loadAllMarkers(
                  loggedInUser.uid,
                  context,
                );
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
