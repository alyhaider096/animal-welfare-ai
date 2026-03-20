import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.putFile(file);

      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception("Image upload failed: $e");
    }
  }
}
