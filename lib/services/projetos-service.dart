import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert'; // For JSON encoding/decoding

import '../model/new_team_member.dart';
import '../model/team_member.dart';

class ProjetosService extends ChangeNotifier {

  // registrar(NewTeamMember newTeamMember) async {
  //   Uri uri = Uri.parse('http://localhost:8080/create/user');
  //   Map<String, dynamic> data = {
  //     'name': newTeamMember.name,
  //     'email': newTeamMember.email,
  //     'cargo': newTeamMember.cargo,
  //     'password': newTeamMember.senha
  //   };
  //
  //   // Encode the data to a JSON string
  //   String body = json.encode(data);
  //
  //   try {
  //     final response = await http.post(
  //       uri,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8', // Specify content type as JSON
  //       },
  //       body: body,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // Request successful, process the response body
  //       print('Response data: ${response.body}');
  //       // Decode JSON response if applicable
  //       final decodedData = json.decode(response.body);
  //       print('Decoded data: $decodedData');
  //     } else {
  //       // Request failed
  //       print('Request failed with status: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // Handle any errors during the request
  //     print('Error during request: $e');
  //   }
  // }


}