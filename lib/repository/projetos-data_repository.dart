import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/projeto_data.dart';

class ProjetosDataRepository extends ChangeNotifier {

  Future<ProjectData> buscarProjetoData(String projetoId) async {
    Uri uri = Uri.parse('http://localhost:8080/projeto-data/${projetoId}');
    ProjectData projetoData = new ProjectData("", "", "", "");
    try {
      final response = await http.get(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8', // Specify content type as JSON
          },
      );

      if (response.statusCode == 200) {
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

Future<ProjectData> save(ProjectData projectData) async {
  Uri uri = Uri.parse('http://localhost:8080/projeto-data');

  // Encode the data to a JSON string
  String body = json.encode(projectData.toJson());

  try {
    final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8', // Specify content type as JSON
        },
        body: body,
    );

    if (response.statusCode == 200) {
      // Request successful, process the response body
      print('Response data: ${response.body}');
      // Decode JSON response if applicable

      projectData = ProjectData.fromJson(response.body as Map<String, dynamic>);

    } else {
      // Request failed
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any errors during the request
    print('Error during request: $e');
  }

  return projectData;
}
}