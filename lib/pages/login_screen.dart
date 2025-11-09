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
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();

  bool? isChecked = false;
  bool _isLoading = false;

  @override
  void dispose() {
    email.dispose();
    senha.dispose();
    super.dispose();
  }

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
                      enabled: !_isLoading,
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
                      enabled: !_isLoading,
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
                    onChanged: _isLoading ? null : (newValue) {
                      setState(() {
                        isChecked = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.platform,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: FilledButton(
                          onPressed: _isLoading ? null : () {
                            login();
                          },
                          child: _isLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text('Entrar')),
                    ),
                  )
                ],
              ),
            )));
  }

  Future<void> login() async {
    // Validação simples
    if (email.text.trim().isEmpty || senha.text.trim().isEmpty) {
      _showErrorDialog('Por favor, preencha todos os campos.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<AuthService>().login(email.text.trim(), senha.text);
      // Se chegou aqui, login foi bem sucedido
      // O AuthCheck vai automaticamente navegar para HomeScreen
    } catch (e) {
      // Mostrar erro
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Erro ao fazer login: ${e.toString()}');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Erro'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}