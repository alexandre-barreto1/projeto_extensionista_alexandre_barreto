import 'dart:developer';

import 'package:flutter/material.dart';

class JogosPage extends StatelessWidget {
  const JogosPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title:
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Lista de jogos', style: TextStyle(color: Colors.white, fontSize: 18)),
          Padding(padding: EdgeInsets.only(right: 25),
          child: Icon(Icons.add_outlined),)
        ],
      ),
      backgroundColor: const Color(0xff576196),
    ),
    body: Container(
        color: Colors.white,
        child: ListView.separated(
          itemCount: 2,
          scrollDirection: Axis.vertical,
          separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.grey,),
          itemBuilder: (BuildContext context, int index) {
            return const ListTile(
              leading: CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(
                    'web/assets/ghost-golfing.jpg'),
              ),
              title: Text('teste                                   5.0', style: TextStyle(fontSize: 20),),
              trailing: Icon(Icons.edit),

            );
          },
          padding: const EdgeInsets.all(16),
        )
    )
    );
}


