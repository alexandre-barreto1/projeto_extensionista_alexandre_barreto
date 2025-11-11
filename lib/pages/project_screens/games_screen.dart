import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_extensionista_alexandre_barreto/model/project.dart';
import 'package:projeto_extensionista_alexandre_barreto/repository/projetos_repository.dart';
import 'game_detail_screen.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  bool _isLoading = true;
  List<Project> _projetos = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarProjetos();
  }

  Future<void> _carregarProjetos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final projetosRepository = Provider.of<ProjetosRepository>(context, listen: false);
      final projetos = await projetosRepository.listAll();

      setState(() {
        _projetos = projetos;
        _isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar projetos: $e");
      setState(() {
        _errorMessage = "Falha ao carregar jogos. Tente novamente.";
        _isLoading = false;
      });
    }
  }

  Map<String, Object> _projectToGameMap(Project project) {
    String? base64String = project.imagemprincipal;
    Uint8List bytes = Uint8List(0);

    if (base64String != null && base64String.isNotEmpty) {
      if (base64String.startsWith('data:image')) {
        base64String = base64String.split(',').last;
      }

      try {
        bytes = base64Decode(base64String);
      } catch (e) {
        print('Erro ao decodificar imagem base64: $e');
      }
    }

    // Processa o QR Code - mantém o base64 original se existir
    String qrData = project.qrcode ?? 'https://sleepkteam.com/games/${project.id}';

    // Log para debug
    print('QR Code para projeto ${project.name}: ${qrData.substring(0, qrData.length > 50 ? 50 : qrData.length)}...');

    return {
      'id': project.id,
      'name': project.name,
      'genre': project.genero ?? 'Não especificado',
      'status': project.status,
      'description': 'Projeto desenvolvido pela equipe SleepK Team',
      'qrData': qrData, // Mantém o base64 ou URL original
      'color': _getColorByGenre(project.genero ?? ''),
      'imagemPrincipal': bytes,
    };
  }

  Color _getColorByGenre(String genre) {
    switch (genre.toLowerCase()) {
      case 'aventura':
      case 'aventura/rpg':
      case 'rpg':
        return const Color(0xFF6A1B9A);
      case 'plataforma':
        return const Color(0xFF0D47A1);
      case 'puzzle':
        return const Color(0xFF00838F);
      case 'ação':
        return const Color(0xFFD32F2F);
      case 'estratégia':
        return const Color(0xFF388E3C);
      default:
        return const Color(0xFF3F4B7C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nossos Jogos'),
        backgroundColor: const Color(0xFF3F4B7C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarProjetos,
            tooltip: 'Recarregar',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF3F4B7C),
            ),
            SizedBox(height: 16),
            Text(
              'Carregando jogos...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF3F4B7C),
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _carregarProjetos,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F4B7C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    if (_projetos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.games_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhum jogo cadastrado ainda',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Em breve novos jogos serão adicionados!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _carregarProjetos,
              icon: const Icon(Icons.refresh),
              label: const Text('Atualizar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F4B7C),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarProjetos,
      color: const Color(0xFF3F4B7C),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _projetos.length,
        itemBuilder: (context, index) {
          final project = _projetos[index];
          final gameMap = _projectToGameMap(project);

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameDetailScreen(game: gameMap),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: (gameMap['imagemPrincipal'] as Uint8List).isNotEmpty
                            ? Image.memory(
                          gameMap['imagemPrincipal'] as Uint8List,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildFallbackImage(gameMap['color'] as Color);
                          },
                        )
                            : _buildFallbackImage(gameMap['color'] as Color),
                      ),
                      // Overlay gradient para melhor legibilidade do texto
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Status chip no topo
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(project.status),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            project.status,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Título e gênero sobre a imagem
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  _getGenreIcon(project.genero ?? ''),
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  project.genero ?? "Não especificado",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Informações do card
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gameMap['description'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GameDetailScreen(game: gameMap),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.info_outline, size: 18),
                              label: const Text('Ver Detalhes'),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF3F4B7C),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GameDetailScreen(game: gameMap),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.qr_code, size: 18),
                              label: const Text('QR Code'),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF4CAF50),
                              ),
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

  Widget _buildFallbackImage(Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.extension,
          size: 80,
          color: Colors.white,
        ),
      ),
    );
  }

  IconData _getGenreIcon(String genre) {
    switch (genre.toLowerCase()) {
      case 'aventura':
      case 'aventura/rpg':
      case 'rpg':
        return Icons.explore;
      case 'plataforma':
        return Icons.videogame_asset;
      case 'puzzle':
        return Icons.extension;
      case 'ação':
        return Icons.sports_martial_arts;
      case 'estratégia':
        return Icons.emoji_objects;
      default:
        return Icons.games;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'lançado':
      case 'concluído':
        return const Color(0xFF4CAF50);
      case 'em desenvolvimento':
      case 'desenvolvimento':
        return const Color(0xFFFF9800);
      case 'beta':
      case 'teste':
        return const Color(0xFF2196F3);
      case 'pausado':
        return const Color(0xFF9E9E9E);
      default:
        return const Color(0xFF4CAF50);
    }
  }
}