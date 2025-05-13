import 'dart:developer';

import 'package:flutter/material.dart';

import 'home.dart';

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
        colorScheme:
        ColorScheme.fromSeed(seedColor: const Color(0xff6750a4), contrastLevel: 1.0),
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

void _login(BuildContext context) async {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const Home()));
}

class _MyHomePageState extends State<MyHomePage> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          toolbarHeight: 250,
          title: Image.asset(
            'web/assets/sleepk-team.png',
            fit: BoxFit.cover,
          ),
          centerTitle: true,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(20.0),
            child: Divider(height: 1, thickness: 3, color: Colors.red),
          ),
        ),
        body: Center(
            child: SizedBox(
          width: 250,
          height: 500,
          child: Column(
            textDirection: TextDirection.ltr,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontSize: 20),
                      labelText: 'E-mail'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontSize: 20),
                      labelText: 'Password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 75, 5),
                child: RichText(
                    text: const TextSpan(
                        style: TextStyle(color: Colors.blue),
                        children: <TextSpan>[
                      TextSpan(
                          text: 'Esqueceu a senha?',
                          style: TextStyle(fontSize: 20)),
                    ])),
              ),
              CheckboxListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 01),
                title: const Text(
                  "Lembrar senha",
                  style: TextStyle(color: Colors.purple, fontSize: 20),
                ),
                value: isChecked,
                onChanged: (newValue) {
                  setState(() {
                    isChecked = newValue;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.platform, //  <-- leading Checkbox
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                child: SizedBox(
                  width: 250, // <-- Your width
                  height: 50, // <-- Your height
                  child: FilledButton(
                      onPressed: () {
                        _login(context);
                      },
                      child: const Text('Entrar')),
                ),
              )
            ],
          ),
        )));
  }
}
