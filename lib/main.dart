import 'package:flutter/material.dart';
import 'package:nursesync/screens/home_screen.dart';

void main() {
  runApp(NurseSyncApp());
}

class NurseSyncApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NurseSync',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomeScreen(),
    );
  }
}
