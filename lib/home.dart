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
            width: 600,
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
                      width: 300,
                      height: 200,
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'web/assets/ghost-golfing.jpg',
                            fit: BoxFit.cover,
                            width: 300,
                            height: 140,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                    ),
                                    child: image != null
                                        ? Image.file(
                                            image,
                                            fit: BoxFit.cover,
                                          )
                                        : networkImg != null && networkImg != ''
                                            ? Image.network(
                                                networkImg,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset('web/assets/ghost-golfing.jpg'),
                                  ),
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
    );
  }
}
