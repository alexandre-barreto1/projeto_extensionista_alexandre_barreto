import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_extensionista_alexandre_barreto/services/auth-services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();

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
        body: Center(
            child: SizedBox(
          width: 250,
          height: 500,
          child: Column(
            textDirection: TextDirection.ltr,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontSize: 20),
                      labelText: 'E-mail'),
                      controller: email,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontSize: 20),
                      labelText: 'Password'),
                      controller: senha,
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
                  isChecked = newValue;
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
                        login();
                      },
                      child: const Text('Entrar')),
                ),
              )
            ],
          ),
        )));
  }

  login() async {
    await context.read<AuthService>().login(email.text, senha.text);
  }

}


