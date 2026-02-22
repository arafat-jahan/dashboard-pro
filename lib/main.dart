import 'package:flutter/material.dart';
import ' widgets/dashboard_screen.dart';

void main() {
  runApp(const VistaPanelApp());
}

class VistaPanelApp extends StatelessWidget {
  const VistaPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "VistaPanel",
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
      ),
      home: const DashboardScreen(),
    );
  }
}