import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final members = [
      {'name': 'João Silva', 'role': 'Game Designer', 'icon': Icons.design_services},
      {'name': 'Maria Santos', 'role': 'Programadora', 'icon': Icons.code},
      {'name': 'Pedro Costa', 'role': 'Artista 2D', 'icon': Icons.brush},
      {'name': 'Ana Oliveira', 'role': 'Compositora', 'icon': Icons.music_note},
      {'name': 'Carlos Souza', 'role': 'Programador', 'icon': Icons.code},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Membros da Equipe'),
        backgroundColor: const Color(0xFF3F4B7C),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF3F4B7C),
                child: Icon(
                  member['icon'] as IconData,
                  color: Colors.white,
                ),
              ),
              title: Text(
                member['name'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(member['role'] as String),
            ),
          );
        },
      ),
    );
  }
}