import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:std_management/functions/firebase_service.dart';
import 'package:std_management/model/std_model.dart';

class Addstudent extends StatefulWidget {
  const Addstudent({super.key});

  @override
  State<Addstudent> createState() => _AddstudentState();
}

class _AddstudentState extends State<Addstudent> {
  final StudentService _studentService = StudentService();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final batchController = TextEditingController();
  final emailController = TextEditingController();
  Uint8List? _profilePicture;

  void addStudent() async {
    final student = Student(
      id: '',
      name: nameController.text,
      age: int.parse(ageController.text),
      email: emailController.text,
      batch: batchController.text,
      imageUrl: '',
    );
    await _studentService.addStudent(student, _profilePicture);
  }

  Future<void> _pickImage() async {
    Uint8List? image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      setState(() {
        _profilePicture = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: _profilePicture != null
                ? CircleAvatar(
                    radius: 60, backgroundImage: MemoryImage(_profilePicture!))
                : const CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        AssetImage('assets/img/default-profile-picture1.jpg')),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid integer';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: batchController,
                    decoration: const InputDecoration(labelText: 'Batch'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter batch';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Gallery'),
                      ),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Camera'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      addStudent();
                      Navigator.pop(context);
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
