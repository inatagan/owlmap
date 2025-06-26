import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkersRepository {
  // Call this when you want to save a marker
  Future<void> saveMarker(
    double lat,
    double lng,
    String userId,
    String title,
    String snippet,
  ) async {
    await FirebaseFirestore.instance.collection('markers').add({
      'userId': userId,
      'latitude': lat,
      'longitude': lng,
      'title': title,
      'snippet': snippet,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // retrieve document
  Future<Set<Marker>> loadUserMarkers(String userId) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('markers')
            .where('userId', isEqualTo: userId)
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Marker(
        markerId: MarkerId(doc.id),
        position: LatLng(data['latitude'], data['longitude']),
        infoWindow: InfoWindow(title: 'Saved Marker'),
      );
    }).toSet();
  }

  // retrieve all markers
  Future<Set<Marker>> loadAllMarkers(String userId) async {
    final markers_set = <Marker>{};
    final snapshot =
        await FirebaseFirestore.instance
            .collection('markers')
            .where('userId', isEqualTo: userId)
            .get();
    for (var doc in snapshot.docs) {
      // print(doc.data());
      markers_set.add(
        Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(doc.data()['latitude'], doc.data()['longitude']),
          infoWindow: InfoWindow(
            title: doc.data()['title'] ?? 'No Title',
            snippet: doc.data()['snippet'] ?? 'No Snippet',
          ),
        ),
      );
    }
    return markers_set;
  }
}
