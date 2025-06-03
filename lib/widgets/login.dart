import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_extensionista_alexandre_barreto/widgets/usuarios.dart';

import 'home.dart';
import 'jogos.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginPage> {
  int currentPageIndex = 0;
  bool isLoggedIn = false;
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
        body: isLoggedIn ? <Widget>[
          //Home
          const HomePage(),
          //Usuarios
          const UsuariosPage(),
          //Jogos
          const JogosPage(),
        ][currentPageIndex]
        :const LoginBody(isChecked),
      bottomNavigationBar: isLoggedIn ? NavigationBar(
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
      ): null,
    );
  }
}


class LoginBody extends StatelessWidget{
  LoginBody(bool? isChecked);

  @override
  Widget build(BuildContext context) {
    return Center(
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
                        //_login(context);
                      },
                      child: const Text('Entrar')),
                ),
              )
            ],
          ),
        ));
  }

}