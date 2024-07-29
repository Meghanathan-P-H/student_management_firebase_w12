import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image to Firebase Storage
  Future<String> uploadImageToStorage(String childName, Uint8List file, String id) async {
    Reference ref = _storage.ref().child(childName).child(id);

    final UploadTask uploadTask = ref.putData(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
