import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_extensionista_alexandre_barreto/pages/project_screens/review_screen.dart';
import 'package:provider/provider.dart';
import '../../widgets/full_screen_wigget.dart';
import '../../widgets/qr_code_widget.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../../repository/projetos_data_repository.dart';
import '../../model/projeto_data.dart';

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
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadProjectData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadProjectData() async {
    setState(() {
      _isLoadingData = true;
      _errorMessage = null;
    });

    try {
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
      print('Erro ao decodificar imagem: $e');
      return null;
    }
  }

  List<Uint8List> _getAllImages() {
    List<Uint8List> images = [];

    // Adiciona imagem principal
    final mainImage = widget.game['imagemPrincipal'] as Uint8List?;
    if (mainImage != null && mainImage.isNotEmpty) {
      images.add(mainImage);
    }

    // Adiciona imagem 1
    if (_projectData?.imagem1 != null && _projectData!.imagem1!.isNotEmpty) {
      final img1Bytes = _decodeBase64Image(_projectData!.imagem1);
      if (img1Bytes != null) {
        images.add(img1Bytes);
      }
    }

    // Adiciona imagem 2
    if (_projectData?.imagem2 != null && _projectData!.imagem2!.isNotEmpty) {
      final img2Bytes = _decodeBase64Image(_projectData!.imagem2);
      if (img2Bytes != null) {
        images.add(img2Bytes);
      }
    }

    return images;
  }

  void _openFullscreenGallery(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullscreenGallery(
          images: _getAllImages(),
          initialIndex: initialIndex,
          gameName: widget.game['name'] as String,
        ),
      ),
    );
  }

  void _openFullscreenQRCode() {
    final qrData = widget.game['qrData'] as String?;

    if (qrData != null && qrData.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenQRCode(
            qrData: qrData,
            gameName: widget.game['name'] as String,
          ),
        ),
      );
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
            // Carrossel de imagens
            _buildImageCarousel(),
            const SizedBox(height: 24),

            // QR Code Section
            GestureDetector(
              onTap: _openFullscreenQRCode,
              child: Container(
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
                child: Stack(
                  children: [
                    Column(
                      children: [
                        _buildQRCode(),
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
                    // Indicador de fullscreen
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
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

  Widget _buildFallbackQR(String data) {
    return Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: QRCodeWidget(data: data),
    );
  }

  Widget _buildImageCarousel() {
    if (_isLoadingData) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3F4B7C),
          ),
        ),
      );
    }

    final images = _getAllImages();

    if (images.isEmpty) {
      // Fallback se não houver imagens
      return Container(
        height: 250,
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
        child: const Center(
          child: Icon(
            Icons.extension,
            size: 100,
            color: Colors.white,
          ),
        ),
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => _openFullscreenGallery(_currentImageIndex),
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.memory(
                        images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: (widget.game['color'] as Color).withOpacity(0.3),
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Indicador de fullscreen
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (images.length > 1) ...[
          const SizedBox(height: 12),
          // Indicadores de página
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentImageIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentImageIndex == index
                      ? const Color(0xFF3F4B7C)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_currentImageIndex + 1} / ${images.length}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQRCode() {
    final qrData = widget.game['qrData'] as String?;

    // Se o QR code for base64, decodifica e exibe como imagem
    if (qrData != null && qrData.isNotEmpty) {
      // Verifica se é base64
      if (qrData.startsWith('data:image') || qrData.length > 100) {
        final qrBytes = _decodeBase64Image(qrData);

        if (qrBytes != null && qrBytes.isNotEmpty) {
          return Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.memory(
                qrBytes,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackQR(qrData);
                },
              ),
            ),
          );
        }
      }

      // Fallback: usa o widget de QR Code gerado
      return _buildFallbackQR(qrData);
    }

    // Se não houver dados, mostra placeholder
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'QR Code\nnão disponível',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}