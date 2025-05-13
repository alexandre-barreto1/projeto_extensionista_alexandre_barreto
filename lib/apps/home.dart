import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
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
                                  backgroundImage: NetworkImage(
                                      'web/assets/ghost-golfing.jpg'),
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
      );
}
