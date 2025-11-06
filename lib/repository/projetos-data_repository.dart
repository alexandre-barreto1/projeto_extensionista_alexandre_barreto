import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/projeto_data.dart';

class ProjetosRepository extends ChangeNotifier {

  Future<ProjectData> buscarProjetoData(String projetoId) async {
    Uri uri = Uri.parse('http://localhost:8080/projeto-data/${projetoId}');
    ProjectData projetoData = {} as ProjectData;
    try {
      final response = await http.get(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8', // Specify content type as JSON
          },
      );

      if (response.statusCode == 200) {
        // Request successful, process the response body
        print('Response data: ${response.body}');
        // Decode JSON response if applicable
        final decodedData = jsonDecode(response.body);

        projetoData = ProjectData.fromJson(decodedData);
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      print('Error during request: $e');
    }

    return projetoData;
  }
}