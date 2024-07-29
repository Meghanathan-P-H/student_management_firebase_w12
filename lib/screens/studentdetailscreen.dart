import 'package:flutter/material.dart';
import 'package:std_management/model/std_model.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.name,style:const TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                // backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage(student.imageUrl ?? ''),
                onBackgroundImageError: (_, __) {
                  const AssetImage('assets/img/default-profile-picture1.jpg');
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
              'Name: ${student.name}',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Age: ${student.age}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${student.email}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Batch: ${student.batch}',
              style: const TextStyle(fontSize: 18),
            ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
