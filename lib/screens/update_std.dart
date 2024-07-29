import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:std_management/functions/firebase_service.dart';
import 'package:std_management/model/std_model.dart';

class Updatestudent extends StatefulWidget {
  final Student student;

  const Updatestudent({super.key, required this.student});

  @override
  State<Updatestudent> createState() => _UpdatestudentState();
}

class _UpdatestudentState extends State<Updatestudent> {
  final StudentService _studentService = StudentService();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final batchController = TextEditingController();
  final emailController = TextEditingController();
  Uint8List? _profilePicture;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.student.name;
    ageController.text = widget.student.age.toString();
    batchController.text = widget.student.batch;
    emailController.text = widget.student.email;
  }

  void updateStudent() async {
    final updatedStudent = Student(
      id: widget.student.id,
      name: nameController.text,
      age: int.parse(ageController.text),
      email: emailController.text,
      batch: batchController.text,
      imageUrl: widget.student.imageUrl,
    );
    await _studentService.updateStudent(
        widget.student.id, updatedStudent, _profilePicture);
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
        title: const Text('Update Student'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: _profilePicture != null
                ? CircleAvatar(
                    radius: 60, backgroundImage: MemoryImage(_profilePicture!))
                : widget.student.imageUrl != null &&
                        widget.student.imageUrl!.isNotEmpty
                    ? CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(widget.student.imageUrl!))
                    : const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(
                            'assets/img/default-profile-picture1.jpg')),
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter age';
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
                      updateStudent();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated Successfully')));
                    },
                    child: const Text('Update'),
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
