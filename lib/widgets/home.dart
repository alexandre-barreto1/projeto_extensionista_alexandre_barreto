import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  get image => null;

  get networkImg => null;

  @override
  Widget build(BuildContext context) {
    int currentPageIndex = 0;

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
      body: Center(
        child: Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            color: const Color(0xff576196),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 33),
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: SizedBox(
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'web/assets/ghost-golfing.jpg',
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CircleAvatar(
                                  radius: 13,
                                  backgroundImage: NetworkImage('web/assets/ghost-golfing.jpg'),
                                ),
                                FilledButton(
                                    style: FilledButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () {},
                                    child: const Text('Jogue Agora!'))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
              },
            )),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        indicatorColor: Colors.purple,
        selectedIndex: currentPageIndex,
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
              Icons.add,
              color: Colors.black45,
              size: 35,
            ),
            label: 'Novo Jogo',
          ),
        ],
      ),
      drawer: const NavigationDrawer(),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildHeader(context),
        buildMenuItems(context)
      ],
    ),
  );

  Widget buildHeader(BuildContext context) => Container();

  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(
      runSpacing: 16,
      children:
        [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: (){},
          ),
          ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Usuários'),
          onTap: (){},
        ),
          ListTile(
            leading: const Icon(Icons.file_open),
            title: const Text('Relatórios'),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.games),
            title: const Text('Jogos'),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Sair'),
            onTap: (){},
          )
        ],
    ),
  );
}
