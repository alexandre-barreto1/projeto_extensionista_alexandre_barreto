import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:projeto_extensionista_alexandre_barreto/widgets/qr_code_widget.dart';

class FullscreenGallery extends StatefulWidget {
  final List<Uint8List> images;
  final int initialIndex;
  final String gameName;

  const FullscreenGallery({
    Key? key,
    required this.images,
    required this.initialIndex,
    required this.gameName,
  }) : super(key: key);

  @override
  State<FullscreenGallery> createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<FullscreenGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.gameName,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              '${_currentIndex + 1} / ${widget.images.length}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Galeria de imagens
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: Image.memory(
                    widget.images[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 80,
                          color: Colors.white54,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          // Indicadores de página na parte inferior
          if (widget.images.length > 1)
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                      (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FullScreenQRCode extends StatefulWidget {
  final String qrData;
  final String gameName;

  const FullScreenQRCode({
    Key? key,
    required this.qrData,
    required this.gameName,
  }) : super(key: key);

  @override
  State<FullScreenQRCode> createState() => _FullscreenQRCodeState();
}

class _FullscreenQRCodeState extends State<FullScreenQRCode> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F4B7C),
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.gameName,
              style: const TextStyle(fontSize: 16),
            ),
            const Text(
              'QR Code',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // QR Code em tamanho grande
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _buildFullscreenQRCode(),
              ),
              const SizedBox(height: 32),
              // Instruções
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F4B7C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: 48,
                      color: const Color(0xFF3F4B7C),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Escaneie este código',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Use a câmera do seu dispositivo para\nobter mais informações sobre o jogo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullscreenQRCode() {
    // Se for base64, decodifica e exibe como imagem
    if (widget.qrData.startsWith('data:image') || widget.qrData.length > 100) {
      final qrBytes = _decodeBase64Image(widget.qrData);

      if (qrBytes != null && qrBytes.isNotEmpty) {
        return SizedBox(
          width: 300,
          height: 300,
          child: Image.memory(
            qrBytes,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildGeneratedQRCode();
            },
          ),
        );
      }
    }

    // Fallback: usa o widget de QR Code gerado
    return _buildGeneratedQRCode();
  }

  Widget _buildGeneratedQRCode() {
    return const SizedBox(
      width: 300,
      height: 300,
      child: QRCodeWidget(data: ''),
    );
  }
}