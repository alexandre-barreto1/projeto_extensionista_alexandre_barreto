import 'package:flutter/material.dart';
import 'package:projeto_extensionista_alexandre_barreto/widgets/auth_check.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleepy k team',
      theme: ThemeData(
        colorScheme:
        ColorScheme.fromSeed(seedColor: const Color(0xff6750a4), contrastLevel: 1.0),
        useMaterial3: true,
      ),
      home: const AuthCheck(),
    );
  }
}

