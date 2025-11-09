import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/team_member.dart';

class AuthService extends ChangeNotifier {
  TeamMember? _user;
  bool isLoading = false;

  TeamMember? get user => _user;

  Future<void> login(String email, String senha) async {
    try {
      isLoading = true;
      notifyListeners();

      Uri uri = Uri.parse('http://localhost:8080/session');
      Map<String, dynamic> data = {
        'email': email,
        'password': senha
      };

      String body = json.encode(data);

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');

        // Corrigido: primeiro decodifica, depois faz o parse
        final decodedData = jsonDecode(response.body);
        TeamMember teamMember = TeamMember.fromJson(decodedData);

        _user = teamMember;
        print("Login realizado com sucesso: ${_user?.name}");

        isLoading = false;
        notifyListeners();
      } else {
        print('Request failed with status: ${response.statusCode}');
        isLoading = false;
        notifyListeners();
        throw Exception('Falha no login: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');
      isLoading = false;
      _user = null;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
    print('Logout realizado com sucesso');
  }

  void updateUser(TeamMember updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}