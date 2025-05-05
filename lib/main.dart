import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo.shade800),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Projeto extensionista'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
        toolbarHeight: 250,
        title: Image.asset('sleepk-team.png', fit: BoxFit.cover),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: SizedBox(
              width: 250,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Password'),
              ),
            ))
          ],
        ),
    ));
  }
}