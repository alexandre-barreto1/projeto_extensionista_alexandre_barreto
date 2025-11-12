import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_extensionista_alexandre_barreto/model/project.dart';
import 'package:projeto_extensionista_alexandre_barreto/repository/projetos_repository.dart';
import 'add_project_screen.dart';

class ManageProjectsScreen extends StatefulWidget {
  const ManageProjectsScreen({Key? key}) : super(key: key);

  @override
  State<ManageProjectsScreen> createState() => _ManageProjectsScreenState();
}

class _ManageProjectsScreenState extends State<ManageProjectsScreen> {
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'lançado':
      case 'concluído':
      case 'finalizado':
        return const Color(0xFF4CAF50);
      case 'em desenvolvimento':
      case 'desenvolvimento':
        return const Color(0xFFFF9800);
      case 'beta':
      case 'teste':
      case 'em teste':
        return const Color(0xFF2196F3);
      case 'pausado':
        return const Color(0xFF9E9E9E);
      default:
        return const Color(0xFF4CAF50);
    }
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

  Uint8List? _decodeBase64Image(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return null;
    }

    try {
      if (base64String.startsWith('data:image')) {
        base64String = base64String.split(',').last;
      }
      return base64Decode(base64String);
    } catch (e) {
      print('Erro ao decodificar imagem base64: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Projetos'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navegar para tela de adicionar projeto
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProjectScreen(),
            ),
          );

          // Se retornou true (sucesso), recarrega a lista
          if (result == true) {
            _carregarProjetos();
          }
        },
        backgroundColor: const Color(0xFF4CAF50),
        icon: const Icon(Icons.add),
        label: const Text('Novo Projeto'),
      ),
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
              'Carregando projetos...',
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
              'Nenhum projeto cadastrado ainda',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Clique no botão abaixo para adicionar',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddProjectScreen(),
                  ),
                );
                if (result == true) {
                  _carregarProjetos();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Projeto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
          return _buildProjectCard(project);
        },
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    final imageBytes = _decodeBase64Image(project.imagemprincipal);
    final color = _getColorByGenre(project.genero ?? '');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Imagem do projeto
              Container(
                height: 180,
                width: double.infinity,
                child: imageBytes != null && imageBytes.isNotEmpty
                    ? Image.memory(
                  imageBytes,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildFallbackImage(color);
                  },
                )
                    : _buildFallbackImage(color),
              ),
              // Overlay gradient
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
              // Status chip
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
              // Título e gênero
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
          // Ações do card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showMessage('Funcionalidade de edição em desenvolvimento');
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Editar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF3F4B7C),
                      side: const BorderSide(color: Color(0xFF3F4B7C)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showDeleteConfirmation(project);
                    },
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Excluir'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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

  void _showDeleteConfirmation(Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 28),
            SizedBox(width: 8),
            Text('Confirmar Exclusão'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tem certeza que deseja excluir este projeto?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gênero: ${project.genero ?? "N/A"}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Text(
                    'Status: ${project.status}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Esta ação não pode ser desfeita.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showMessage('Funcionalidade de exclusão em desenvolvimento');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF3F4B7C),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}