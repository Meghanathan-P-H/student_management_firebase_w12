import 'package:flutter/material.dart';
import 'package:std_management/functions/firebase_service.dart';
import 'package:std_management/model/std_model.dart';
import 'package:std_management/screens/SearchStudentScreen.dart';
import 'package:std_management/screens/add_student_screen.dart';
import 'package:std_management/screens/studentdetailscreen.dart';
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
        title: const Text(
          'Student Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchStudentScreen()),
                );
              },
              icon: const Icon(
                Icons.person_search,
                size: 40,
                color: Colors.black,
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Addstudent()));
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
          return LayoutBuilder(builder: (context, constraints) {
            int crossAxisCount = 2;
            if (constraints.maxWidth > 600) {
              crossAxisCount = 3;
            }
            if (constraints.maxWidth > 900) {
              crossAxisCount = 4;
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 2 / 3,
              ),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentDetailScreen(student: student),
                      ),
                    );
                  },
                  child: Center(
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: (student.imageUrl != null &&
                                            student.imageUrl!.isNotEmpty)
                                        ? NetworkImage(student.imageUrl!)
                                        : const AssetImage(
                                                'assets/img/default-profile-picture1.jpg')
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              student.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Age: ${student.age}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Updatestudent(student: student),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blueGrey,
                                  ),
                                  iconSize: 30,
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: const Text(
                                              'Are you sure you want to delete this student?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _studentService
                                                    .deleteStudent(student.id);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  iconSize: 30,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          });
        },
      ),
    );
  }
}
