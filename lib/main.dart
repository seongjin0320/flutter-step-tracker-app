import 'package:flutter/material.dart';
import 'home_screen.dart'; // You'll create this file next

void main() {
  runApp(const StepTrackerApp());
}

class StepTrackerApp extends StatelessWidget {
  const StepTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Step Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
