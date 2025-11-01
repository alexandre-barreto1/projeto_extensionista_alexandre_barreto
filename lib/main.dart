import 'package:flutter/material.dart';
import 'package:projeto_extensionista_alexandre_barreto/app_start.dart';
import 'package:projeto_extensionista_alexandre_barreto/repository/projetos_repository.dart';
import 'package:projeto_extensionista_alexandre_barreto/repository/team_member_repository.dart';
import 'package:provider/provider.dart';
import 'services/auth-services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthService()),
          ChangeNotifierProvider(create: (context) => TeamMemberRepository()),
          ChangeNotifierProvider(create: (context) => ProjetosRepository())
        ],
        child: const AppStart(),
  ));

}