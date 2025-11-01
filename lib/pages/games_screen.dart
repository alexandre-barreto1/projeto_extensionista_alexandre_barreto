import 'package:flutter/material.dart';

import 'game_detail_screen.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final games = [
      {
        'name': 'Dream Quest',
        'genre': 'Aventura/RPG',
        'status': 'Em Desenvolvimento',
        'description': 'Um jogo de aventura em mundo aberto com elementos de RPG.',
        'qrData': 'https://sleepkteam.com/games/dream-quest',
        'color': const Color(0xFF6A1B9A),
        'icon': Icons.explore,
      },
      {
        'name': 'Night Runner',
        'genre': 'Plataforma',
        'status': 'Lançado',
        'description': 'Jogo de plataforma 2D com mecânicas de parkour noturno.',
        'qrData': 'https://sleepkteam.com/games/night-runner',
        'color': const Color(0xFF0D47A1),
        'icon': Icons.directions_run,
      },
      {
        'name': 'Sleepy Puzzle',
        'genre': 'Puzzle',
        'status': 'Beta',
        'description': 'Jogo de quebra-cabeças relaxante com temática onírica.',
        'qrData': 'https://sleepkteam.com/games/sleepy-puzzle',
        'color': const Color(0xFF00838F),
        'icon': Icons.extension,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nossos Jogos'),
        backgroundColor: const Color(0xFF3F4B7C),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameDetailScreen(game: game),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Game Image Banner
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          game['color'] as Color,
                          (game['color'] as Color).withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        game['icon'] as IconData,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                game['name'] as String,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Chip(
                              label: Text(
                                game['status'] as String,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: const Color(0xFF4CAF50).withOpacity(0.2),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gênero: ${game['genre']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          game['description'] as String,
                          style: const TextStyle(fontSize: 14, height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GameDetailScreen(game: game),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.qr_code),
                              label: const Text('Ver QR Code'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}