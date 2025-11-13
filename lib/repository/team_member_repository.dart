import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../model/team_member.dart';
import 'package:http/http.dart' as http;

class TeamMemberRepository extends ChangeNotifier {

  Future<List<TeamMember>> listAll() async {
    Uri uri = Uri.parse('http://localhost:8080/list/user');
    List<TeamMember> teamMember = [];
    try {
      final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8', // Specify content type as JSON
          }
      );

      if (response.statusCode == 200) {
        // Request successful, process the response body
        print('Response data: ${response.body}');
        // Decode JSON response if applicable
        final decodedData = jsonDecode(response.body);

        for (var proj in decodedData) {
          teamMember.add(TeamMember.fromJson(proj));
        }
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      print('Error during request: $e');
    }

    return teamMember;
  }

Future<TeamMember> update(TeamMember teamMember) async {
  Uri uri = Uri.parse('http://localhost:8080/user');

  // Encode the data to a JSON string
  String body = json.encode(teamMember.toJson());

  try {
    final response = await http.put(
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

      teamMember = TeamMember.fromJson(response.body as Map<String, dynamic>);

    } else {
      // Request failed
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any errors during the request
    print('Error during request: $e');
  }

  return teamMember;
}

  Future<void> changePass(String id, String password, String currentPassword) async {
    Uri uri = Uri.parse('http://localhost:8080/user/change-pass');

    // Encode the data to a JSON string
    String body = json.encode({
      'id_usuario' : id,
      'password' : password,
      'currentPassword': currentPassword
    });

    try {
      final response = await http.put(
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

      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      print('Error during request: $e');
    }
  }

Future<TeamMember> save(TeamMember teamMember) async {
  Uri uri = Uri.parse('http://localhost:8080/create/user');

  // Encode the data to a JSON string
  String body = json.encode(teamMember.toJson());

  try {
    final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8', // Specify content type as JSON
        },
        body: body,
    );

    if (response.statusCode == 200) {

      print('Response data: ${response.body}');

      final decodedData = jsonDecode(response.body);

      teamMember = TeamMember.fromJson(decodedData);
    } else {
      // Request failed
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any errors during the request
    print('Error during request: $e');
  }

  return teamMember;
}

}