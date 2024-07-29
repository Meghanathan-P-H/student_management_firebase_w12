import 'package:flutter/material.dart';
import 'package:std_management/functions/firebase_service.dart';
import 'package:std_management/model/std_model.dart';
import 'package:std_management/screens/add_student_screen.dart';
import 'package:std_management/screens/update_std.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final StudentService _studentService = StudentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management'),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Addstudent()));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, size: 35),
      ),
      body: StreamBuilder<List<Student>>(
        stream: _studentService.getStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found'));
          }

          final students = snapshot.data!;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              print('Image URL: ${student.imageUrl}'); // Debugging URL

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 80,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade200,
                        child: ClipOval(
                          child: Image.network(
                            student.imageUrl ?? '',
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Image.asset('assets/img/default-profile-picture1.jpg', fit: BoxFit.cover, width: 60, height: 60);
                            },
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Age: ${student.age}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                          Text(
                            'Batch: ${student.batch}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Updatestudent(student: student),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            iconSize: 30,
                          ),
                          IconButton(
                            onPressed: () {
                              _studentService.deleteStudent(student.id);
                            },
                            icon: const Icon(Icons.delete),
                            iconSize: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
