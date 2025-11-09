import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../model/team_member.dart';
import 'package:http/http.dart' as http;

/// adicionar esse repository no main()
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

  Future<TeamMember> buscarProjetoData(String userId) async {
    Uri uri = Uri.parse('http://localhost:8080/projeto-data/${userId}');
    TeamMember teamMember = TeamMember("", "", "", "", "");
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