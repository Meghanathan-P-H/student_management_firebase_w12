import 'package:flutter/material.dart';
import 'package:std_management/screens/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Student Management",
      theme: ThemeData(primaryColor: Colors.blue),
      home: const Homescreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
