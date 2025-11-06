import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_extensionista_alexandre_barreto/model/project.dart';

class GamesScreenHelper {
  // Cache para a imagem padrão
  static Uint8List? _defaultImageCache;

  // Carrega a imagem padrão uma única vez
  static Future<Uint8List> _loadDefaultImage() async {
    if (_defaultImageCache != null) {
      return _defaultImageCache!;
    }

    try {
      final ByteData data = await rootBundle.load('images/projeto-imagem-padrao.png');
      _defaultImageCache = data.buffer.asUint8List();
      return _defaultImageCache!;
    } catch (e) {
      print('Erro ao carregar imagem padrão: $e');
      // Retorna um pixel transparente como fallback
      return Uint8List.fromList([0]);
    }
  }

  // Método assíncrono para converter Project em Map
  static Future<Map<String, Object>> projectToGameMap(
      Project project,
      Color Function(String) getColorByGenre,
      ) async {
    Uint8List bytes;

    if (project.imagemprincipal != null && project.imagemprincipal!.isNotEmpty) {
      String base64String = project.imagemprincipal!;

      // Remove prefixo se necessário
      if (base64String.startsWith('data:image')) {
        base64String = base64String.split(',').last;
      }

      try {
        bytes = base64Decode(base64String);
      } catch (e) {
        print('Erro ao decodificar imagem base64: $e');
        // Se falhar, carrega a imagem padrão
        bytes = await _loadDefaultImage();
      }
    } else {
      // Carrega a imagem padrão dos assets
      bytes = await _loadDefaultImage();
    }

    return {
      'name': project.name,
      'genre': project.genero ?? 'Não especificado',
      'status': project.status,
      'description': 'Projeto desenvolvido pela equipe SleepK Team',
      'qrData': project.qrcode ?? '',
      'color': getColorByGenre(project.genero ?? ''),
      'imagemPrincipal': bytes,
    };
  }

}