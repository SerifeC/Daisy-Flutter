import 'dart:io';

import 'package:daisy/features/auth/data/datasources/storage_base_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class FirebaseStorageService implements StorageBase {
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  firebase_storage.Reference _storageReference;

  @override
  Future<String> uploadFile(String userID, String fileType, File loadingFile) async {
    _storageReference = firebase_storage.FirebaseStorage.instance.ref().child(userID).child(fileType).child("profil_foto.png");

    firebase_storage.UploadTask uploadTask = _storageReference.putFile(loadingFile);

    firebase_storage.TaskSnapshot snapshot = await uploadTask;

    var url = await _storageReference.getDownloadURL();
    return url;
  }
}