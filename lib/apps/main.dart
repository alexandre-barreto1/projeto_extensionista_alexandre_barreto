import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:projeto_extensionista_alexandre_barreto/apps/jogos.dart';
import 'package:projeto_extensionista_alexandre_barreto/apps/relatorios.dart';

import 'equipe.dart';
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

class _MyHomePageState extends State<MyHomePage> {
  bool? isChecked = false;
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        toolbarHeight: 80,
        title: Image.asset(
          'web/assets/sleepk-team.png',
          fit: BoxFit.cover,
          height: 50,
        ),
        centerTitle: true,
      ),
      body: <Widget>[
        //Home
        const HomePage(),
        //Equipe
        const EquipePage(),
        //Jogos
        const JogosPage(),
        //Relatorios
        const RelatoriosPage()
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.black45,
              size: 35,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person,
              color: Colors.black45,
              size: 35,
            ),
            label: 'Equipe',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.games,
              color: Colors.black45,
              size: 35,
            ),
            label: 'Jogos',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.file_copy,
              color: Colors.black45,
              size: 35,
            ),
            label: 'Relatórios',
          ),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        indicatorColor: Colors.purple,
      ),
    );
  }
}


