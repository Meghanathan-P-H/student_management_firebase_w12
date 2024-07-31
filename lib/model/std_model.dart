import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String name;
  final int age;
  final String email;
  final String batch;
   final String? imageUrl;
 

  Student({
    required this.id,
    required this.name,
    required this.age,
    required this.email,
    required this.batch,
    required this.imageUrl,
    
  });

 
  factory Student.fromDocument(DocumentSnapshot doc) {
    return Student(
      id: doc.id,
      name: doc['name'],
      age: int.parse(doc['age']),
      email: doc['email'],
      batch: doc['batch'],
      imageUrl: doc['imageUrl'],
      
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age.toString(),
      'email': email,
      'batch': batch,
      'imageUrl': imageUrl,
    };
  }
}
