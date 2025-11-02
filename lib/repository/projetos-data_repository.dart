import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:projeto_extensionista_alexandre_barreto/model/project.dart';
import 'package:http/http.dart' as http;

class ProjetosRepository extends ChangeNotifier {

  Future<List<Project>> buscarProjetoData(String projetoId) async {
    Uri uri = Uri.parse('http://localhost:8080/get/projeto-data');
    List<Project> projetos = [];
    try {
      final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8', // Specify content type as JSON
          },
        body: projetoId,
      );

      if (response.statusCode == 200) {
        // Request successful, process the response body
        print('Response data: ${response.body}');
        // Decode JSON response if applicable
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
}