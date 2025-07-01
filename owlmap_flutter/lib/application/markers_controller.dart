import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:owlmap/data/markers_repository.dart';
import 'package:quickalert/quickalert.dart';

class MarkersController extends ChangeNotifier {
  final MarkersRepository _markersRepository = MarkersRepository();
  Set<Marker> markers = {};
  late GoogleMapController _mapsController;

  get mapsController => _mapsController;

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    // getPosicao();
  }

  Future<void> saveMarker(
    double lat,
    double lng,
    String userId,
    String title,
    String snippet,
  ) async {
    await _markersRepository.saveMarker(lat, lng, userId, title, snippet);
  }

  Future<Set<Marker>> loadUserMarkers(String userId) async {
    return await _markersRepository.loadUserMarkers(userId);
  }

  Future<Set<Marker>> loadAllMarkers(
    String userId,
    BuildContext context,
  ) async {
    final savedMarkers = await _markersRepository.loadAllMarkers(userId);
    for (var marker in savedMarkers) {
      markers.add(
        Marker(
          markerId: marker.markerId,
          position: marker.position,
          infoWindow: marker.infoWindow,
          icon: await BitmapDescriptor.asset(
            ImageConfiguration(size: Size(48, 48)),
            'assets/images/owl_light_512.png',
          ),
          onTap: () {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.info,
              title: marker.infoWindow.title ?? 'Marker',
              text: marker.infoWindow.snippet ?? 'No Snippet',
            );
          },
        ),
      );
    }
    return markers;
  }
}
