import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _storage = FirebaseStorage.instance;

class MediaRepository {
  Future<String> uploadImage(String userId, String filePath) async {
    try {
      final fileName =
          'profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref(fileName);
      await ref.putFile(File(filePath));
      return ref.getDownloadURL();
      print('Image uploaded successfully: $fileName');
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<String> updateUserProfileImage(String userId, String filePath) async {
    try {
      final downloadUrl = await uploadImage(userId, filePath);
      await FirebaseFirestore.instance.collection('userProfile').add({
        'userId': userId,
        'profileImageUrl': downloadUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      // Here you would typically update the user's profile with the new image URL
      // For example, using Firebase Firestore or Realtime Database
      return downloadUrl;
    } catch (e) {
      print('Error updating user profile image: $e');
      throw Exception('Failed to update user profile image: $e');
    }
  }
}
