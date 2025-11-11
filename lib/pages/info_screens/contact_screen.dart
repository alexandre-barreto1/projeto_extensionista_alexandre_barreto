import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contato'),
        backgroundColor: const Color(0xFF3F4B7C),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Entre em Contato',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F4B7C),
              ),
            ),
            const SizedBox(height: 20),
            _buildContactCard(
              Icons.email,
              'Email',
              'contato@sleepkteam.com',
            ),
            _buildContactCard(
              Icons.phone,
              'Telefone',
              '+55 (99) 9 9999-9999',
            ),
            _buildContactCard(
              Icons.language,
              'Website',
              'www.sleepkteam.com',
            ),
            _buildContactCard(
              Icons.location_on,
              'Localização',
              'Florianópolis, Brasil',
            ),
            const SizedBox(height: 30),
            const Text(
              'Siga-nos nas redes sociais',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildSocialButton(Icons.facebook, () {}),
                _buildSocialButton(Icons.camera_alt, () {}),
                _buildSocialButton(Icons.play_arrow, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF3F4B7C)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        child: CircleAvatar(
          backgroundColor: const Color(0xFF3F4B7C),
          radius: 24,
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}