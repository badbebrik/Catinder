import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'widgets//home_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const CatotinderApp());
}

class CatotinderApp extends StatelessWidget {
  const CatotinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catinder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
