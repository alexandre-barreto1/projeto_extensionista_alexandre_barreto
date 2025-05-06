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


final List<Widget> esqueceuSenhaButtom = <Widget>[
  TextButton(
    style: TextButton.styleFrom(overlayColor: Colors.blue),
    onPressed: () {},
    child: const Text('Esqueceu a senha?'),
  ),
];

class _MyHomePageState extends State<MyHomePage> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
        toolbarHeight: 250,
        title: Image.asset('web/assets/sleepk-team.png', fit: BoxFit.cover,),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: Divider(height: 1, thickness: 3, color: Colors.red),
        ),
      ),
      body: Center(
        child: Column(
          children: [
        const Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: SizedBox(
              width: 250,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'E-mail'),
              ),
            )),
            const Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: SizedBox(
                  width: 250,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Password'),
                  ),
                )),
            Padding(padding: const EdgeInsets.fromLTRB(0, 5, 130,0),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                    child: Column(children: esqueceuSenhaButtom),
                  )
                ),
            Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          tristate: true,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value;
                            });
                          },
                        ),
                        const Text.rich(
                          TextSpan(
                              text: 'Lembrar a senha',
                              style: TextStyle(color: Colors.purple)// default text style
                          ),
                        )
                      ],
                    ),
                  ],
                )
            )
            ,
          ],
        ),
    ));
  }
}