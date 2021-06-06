import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  FirebaseStorageService._privateConstructor();

  static final FirebaseStorageService instance =
      FirebaseStorageService._privateConstructor();
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadProductPic(File file, String fileName) async {
    String downloadUrl;
    final uploadTask = storage.ref('images/$fileName').putFile(file);
    await uploadTask.whenComplete(() async =>
        downloadUrl = await uploadTask.snapshot.ref.getDownloadURL());
    return downloadUrl;
  }
}
