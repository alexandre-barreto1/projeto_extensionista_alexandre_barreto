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
    _carregarProjetos(); // Chama o método para carregar os dados
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

  // Método auxiliar para converter Project em Map para o GameDetailScreen
  Map<String, Object> _projectToGameMap(Project project) {
    String? base64String = project.imagemprincipal;

    // Inicializa com um Uint8List vazio
    Uint8List bytes = Uint8List(0);

    // Se houver base64 válido
    if (base64String != null && base64String.isNotEmpty) {
      // Remove prefixo se necessário
      if (base64String.startsWith('data:image')) {
        base64String = base64String.split(',').last;
      }

      try {
        bytes = base64Decode(base64String);
      } catch (e) {
        print('Erro ao decodificar imagem base64: $e');
      }
    }

    return {
      'name': project.name,
      'genre': project.genero ?? 'Não especificado',
      'status': project.status,
      'description': 'Projeto desenvolvido pela equipe SleepK Team',
      'qrData': project.qrcode ?? 'https://sleepkteam.com/games/${project.id}',
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
                  // Game Image Banner
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          gameMap['color'] as Color,
                          (gameMap['color'] as Color).withOpacity(0.7),
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
                      child:
                      (gameMap['imagemPrincipal'] != null)
                          ?
                        const Icon(
                          Icons.extension,
                          size: 100,
                          color: Colors.white,
                        )
                       :
                      Image.memory(
                          gameMap['imagemPrincipal'] as Uint8List,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        )
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
                                project.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Chip(
                              label: Text(
                                project.status,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: _getStatusColor(project.status),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gênero: ${project.genero ?? "Não especificado"}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          gameMap['description'] as String,
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
                                    builder: (context) => GameDetailScreen(game: gameMap),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'lançado':
      case 'concluído':
        return const Color(0xFF4CAF50).withOpacity(0.2);
      case 'em desenvolvimento':
      case 'desenvolvimento':
        return const Color(0xFFFF9800).withOpacity(0.2);
      case 'beta':
      case 'teste':
        return const Color(0xFF2196F3).withOpacity(0.2);
      case 'pausado':
        return const Color(0xFF9E9E9E).withOpacity(0.2);
      default:
        return const Color(0xFF4CAF50).withOpacity(0.2);
    }
  }
}