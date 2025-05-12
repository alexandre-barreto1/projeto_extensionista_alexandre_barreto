import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
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
            child: ListView.separated(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 35),
              itemCount: 2,
              separatorBuilder: (BuildContext context, int index) =>
                  const Spacer(),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Card(
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
                                const Icon(
                                  Icons.audiotrack,
                                  color: Colors.green,
                                  size: 30.0,
                                ),
                                FilledButton(
                                    onPressed: () {},
                                    child: const Text('Entrar'))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
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
            icon: Icon(Icons.home_outlined, color: Colors.black26,),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_sharp, color: Colors.black26,),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.messenger_sharp, color: Colors.black26,),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
}
