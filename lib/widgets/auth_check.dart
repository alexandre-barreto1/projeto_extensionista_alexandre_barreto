import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_extensionista_alexandre_barreto/pages/login_screen.dart';
import 'package:projeto_extensionista_alexandre_barreto/services/auth-services.dart';
import 'package:provider/provider.dart';

import '../pages/home_screen.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck>{

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        print("Usuário atual: ${authService.user}");
        if (authService.user == null) {
          print("AAAA");
          return const LoginPage();
        } else {
          return const HomeScreen();
        }
      },
    );
  }


  // loading() {
  //   return const Scaffold(
  //     body: Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );
  // }
}