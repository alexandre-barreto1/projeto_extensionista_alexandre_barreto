
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_extensionista_alexandre_barreto/pages/review_screen.dart';
import 'package:provider/provider.dart';
import '../widgets/qr_code_widget.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../repository/projetos-data_repository.dart';
import '../model/projeto_data.dart';

class GameDetailScreen extends StatefulWidget {
  final Map<String, dynamic> game;

  const GameDetailScreen({Key? key, required this.game}) : super(key: key);

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  ProjectData? _projectData;
  bool _isLoadingData = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProjectData();
  }

  Future<void> _loadProjectData() async {

    setState(() {
      _isLoadingData = true;
      _errorMessage = null;
    });

    try {
      // Obtém o ID do projeto do game map
      final projectId = widget.game['id'] as String?;

      if (projectId != null && projectId.isNotEmpty) {
        final projetosDataRepository = Provider.of<ProjetosDataRepository>(
            context,
            listen: false
        );

        final projectData = await projetosDataRepository.buscarProjetoData(projectId);

        setState(() {
          _projectData = projectData;
          _isLoadingData = false;
        });
      } else {
        setState(() {
          _isLoadingData = false;
          _errorMessage = 'ID do projeto não encontrado';
        });
      }
    } catch (e) {
      print('Erro ao carregar dados do projeto: $e');
      setState(() {
        _isLoadingData = false;
        _errorMessage = 'Não foi possível carregar informações adicionais';
      });
    }
  }

  // Converte base64 para Uint8List
  Uint8List? _decodeBase64Image(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return null;
    }

    try {
      // Remove prefixo se necessário
      if (base64String.startsWith('data:image')) {
        base64String = base64String.split(',').last;
      }
      return base64Decode(base64String);
    } catch (e) {
      print('Erro ao decodificar imagem: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game['name'] as String),
        backgroundColor: const Color(0xFF3F4B7C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Game Banner Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.game['color'] as Color,
                    (widget.game['color'] as Color).withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: (widget.game['imagemPrincipal'] != null &&
                    (widget.game['imagemPrincipal'] as Uint8List).isNotEmpty)
                    ? Image.memory(
                  widget.game['imagemPrincipal'] as Uint8List,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.extension,
                      size: 100,
                      color: Colors.white,
                    );
                  },
                )
                    : const Icon(
                  Icons.extension,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Screenshot Gallery - Agora com dados reais se disponível
            _buildGallerySection(),

            const SizedBox(height: 24),

            // QR Code Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  QRCodeWidget(data: widget.game['qrData'] as String),
                  const SizedBox(height: 12),
                  Text(
                    'Escaneie para mais informações',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Project Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3F4B7C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.game['name'] as String,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gênero: ${widget.game['genre']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status: ${widget.game['status']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.game['description'] as String,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Review Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(game: widget.game),
                    ),
                  );
                },
                icon: const Icon(Icons.star),
                label: const Text('Avaliar Jogo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGallerySection() {
    if (_isLoadingData) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3F4B7C),
          ),
        ),
      );
    }

    if (_projectData != null) {
      return _buildGallery();
    }

    // Galeria padrão se não houver dados
    return _buildDefaultGallery();
  }

  Widget _buildGallery() {
    final List<Widget> galleryItems = [];

    // Adiciona imagem 1
    if (_projectData!.imagem1 != null && _projectData!.imagem1!.isNotEmpty) {
      final img1Bytes = _decodeBase64Image(_projectData!.imagem1);
      if (img1Bytes != null) {
        print('images ${img1Bytes}');
        galleryItems.add(_buildGalleryItem(img1Bytes, Icons.image));
      }
    }

    // Adiciona imagem 2
    if (_projectData!.imagem2 != null && _projectData!.imagem2!.isNotEmpty) {
      final img2Bytes = _decodeBase64Image(_projectData!.imagem2);
      if (img2Bytes != null) {
        galleryItems.add(_buildGalleryItem(img2Bytes, Icons.photo_library));
      }
    }

    // Se não houver itens, mostra galeria padrão
    if (galleryItems.isEmpty) {
      return _buildDefaultGallery();
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: galleryItems.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: galleryItems[index],
          );
        },
      ),
    );
  }

  Widget _buildGalleryItem(Uint8List imageBytes, IconData fallbackIcon) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          imageBytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: (widget.game['color'] as Color).withOpacity(0.3),
              child: Center(
                child: Icon(
                  fallbackIcon,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDefaultGallery() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (widget.game['color'] as Color).withOpacity(0.5),
                  (widget.game['color'] as Color).withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                index == 0
                    ? Icons.image
                    : index == 1
                    ? Icons.photo_library
                    : Icons.play_circle_outline,
                size: 40,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}