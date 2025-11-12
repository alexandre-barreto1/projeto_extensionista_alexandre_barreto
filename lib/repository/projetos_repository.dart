import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:projeto_extensionista_alexandre_barreto/dto/media_avaliacao_dto.dart';
import 'package:projeto_extensionista_alexandre_barreto/model/project.dart';
import 'package:http/http.dart' as http;

import '../model/projeto_avaliacao.dart';

class ProjetosRepository extends ChangeNotifier {

  Future<List<Project>> listAll() async {
    Uri uri = Uri.parse('http://localhost:8080/projetos');
    List<Project> projetos = [];
    try {
      final response = await http.post(uri, headers: <String, String>{
        'Content-Type':
            'application/json; charset=UTF-8', // Specify content type as JSON
      });

      if (response.statusCode == 200) {

        final decodedData = jsonDecode(response.body);

        for (var proj in decodedData) {
          projetos.add(Project.fromJson(proj));
        }
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      print('Error during request: $e');
    }

    return projetos;
  }

  Future<ProjetoAvaliacao> salvarAvaliacao(
      ProjetoAvaliacao projectAvalicao) async {
    Uri uri = Uri.parse('http://localhost:8080/projeto-avaliacao');
    String body = json.encode(projectAvalicao.toJson());
    try {
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type':
                'application/json; charset=UTF-8', // Specify content type as JSON
          },
          body: body);

      if (response.statusCode == 200) {
        // Request successful, process the response body
        print('Response data: ${response.body}');
        // Decode JSON response if applicable
        final decodedData = jsonDecode(response.body);

        projectAvalicao = ProjetoAvaliacao.fromJson(decodedData);
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      print('Error during request: $e');
    }

    return projectAvalicao;
  }

  Future<Project> save(Project project) async {
    Uri uri = Uri.parse('http://localhost:8080/projeto');

    // Encode the data to a JSON string
    String body = json.encode(project.toJson());

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type':
              'application/json; charset=UTF-8', // Specify content type as JSON
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        project = Project.fromJson(decodedData);
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      print('Error during request: $e');
    }

    return project;
  }

  Future<MediaAvaliacaoDto> mediaAvaliacoes(String projetoId, String perildo) async {
    Uri uri = Uri.parse('http://localhost:8080/projeto-media-avaliacao');
    MediaAvaliacaoDto mediaAvaliacaoDto = MediaAvaliacaoDto("", 0, 0, 0, 0, 0, []);

    String body = json.encode({
      'projetoId': projetoId,
      'perildo': perildo,
    });

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type':
          'application/json; charset=UTF-8', // Specify content type as JSON
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        mediaAvaliacaoDto = MediaAvaliacaoDto.fromJson(decodedData);
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      print('Error during request: $e');
    }

    return mediaAvaliacaoDto;
  }
}
