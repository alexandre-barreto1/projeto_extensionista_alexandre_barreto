import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding

import '../model/team_member.dart';

class AuthService extends ChangeNotifier {
  TeamMember? _user;

  bool isLoading = true;

  TeamMember? get user => _user;


  login(String email, String senha) async {
    Uri uri = Uri.parse('http://localhost:8080/session');
    Map<String, dynamic> data = {
      'email': email,
      'password': senha
    };

    // Encode the data to a JSON string
    String body = json.encode(data);

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
        TeamMember teamMember = TeamMember.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

        _user = teamMember;

        print("novo loginm: ${_user}");

        notifyListeners();
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      print('Error during request: $e');
    }
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }


}