import 'package:flutter/cupertino.dart';

class TeamMember {
  final String id;
  final String name;
  final String email;
  final String cargo;
  final String token;

  TeamMember(this.id, this.name, this.email, this.cargo, this.token);

  TeamMember.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        email = json['email'] as String,
        cargo = json['cargo'] as String,
        token = json['token'] as String;
}

// class TeamMemberModel extends ChangeNotifier {
//   TeamMember? _user;
//
//   bool isLoading = true;
//
//   TeamMember? get user => _user;
//
//   void setUser(TeamMember user) {
//
//     print("aquie");
//
//
//     _user = user;
//     isLoading = false;
//     notifyListeners(); // Notifica os ouvintes que o estado mudou
//   }
//
//   void clearUser() {
//     _user = null;
//     notifyListeners();
//   }
//
// }