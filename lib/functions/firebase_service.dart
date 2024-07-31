// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:std_management/model/std_model.dart';
import 'package:uuid/uuid.dart';
import 'package:std_management/functions/storage_method.dart';

class StudentService {
  static final CollectionReference studentsCollection = FirebaseFirestore.instance.collection('students');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> addStudent(Student student, Uint8List? profilePicture) async {
    String studentId = const Uuid().v1();
    try {
      String imgUrl = '';
      if (profilePicture != null) {
        imgUrl = await StorageMethod().uploadImageToStorage('profileImage', profilePicture, studentId);
      }
      final newStudent = Student(
        id: studentId,
        name: student.name,
        age: student.age,
        email: student.email,
        batch: student.batch,
        imageUrl: imgUrl,
      );
      await studentsCollection.doc(studentId).set(newStudent.toJson());
      return 'successfully added student';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateStudent(String id, Student student, Uint8List? profilePicture) async {
    try {
      String imgUrl = student.imageUrl ?? '';
      if (profilePicture != null) {
        imgUrl = await StorageMethod().uploadImageToStorage('profileImage', profilePicture, id);
      }
      final updatedStudent = Student(
        id: id,
        name: student.name,
        age: student.age,
        email: student.email,
        batch: student.batch,
        imageUrl: imgUrl,
      );
      await studentsCollection.doc(id).update(updatedStudent.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      DocumentSnapshot docSnapshot = await studentsCollection.doc(id).get();
      if (docSnapshot.exists) {
        Student student = Student.fromDocument(docSnapshot);
        String imageUrl = student.imageUrl ?? '';

        if (imageUrl.isNotEmpty) {
          // Delete the image Firebase Storage///
          Reference imageRef = _storage.refFromURL(imageUrl);
          await imageRef.delete();
        }

        // Delete the student document Firestore////
        await studentsCollection.doc(id).delete();
      }
    } catch (e) {
      print('Error deleting student: $e');
    }
  }

  
  Stream<List<Student>> getStudents() {
    return studentsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Student.fromDocument(doc)).toList();
    });
  }
  
}
