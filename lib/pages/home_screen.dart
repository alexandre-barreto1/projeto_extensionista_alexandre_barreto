import 'package:flutter/material.dart';
import 'package:projeto_extensionista_alexandre_barreto/pages/project_screens/games_screen.dart';
import 'profile_screen.dart';
import 'about_screen.dart';
import 'members_screen.dart';
import 'contact_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SleepK Team'),
        backgroundColor: const Color(0xFF3F4B7C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            context,
            'Sobre a Equipe',
            'Conheça o SleepK Team',
            Icons.people,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            ),
          ),
          _buildCard(
            context,
            'Nossos Jogos',
            'Veja nosso portfólio',
            Icons.sports_esports,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GamesScreen()),
            ),
          ),
          _buildCard(
            context,
            'Membros',
            'Desenvolvedores e artistas',
            Icons.badge,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MembersScreen()),
            ),
          ),
          _buildCard(
            context,
            'Contato',
            'Entre em contato conosco',
            Icons.email,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactScreen()),
            ),
          ),
          _buildCard(
            context,
            'Configurações',
            'Editar perfil e opções',
            Icons.settings,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String subtitle,
      IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF3F4B7C), size: 32),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}