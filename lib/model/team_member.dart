import 'package:flutter/cupertino.dart';

class TeamMember {
  final String id;
  final String name;
  final String email;
  final String cargo;

  TeamMember(this.id, this.name, this.email, this.cargo);

  TeamMember.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        email = json['email'] as String,
        cargo = json['cargo'] as String;

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
      'email' : email,
      'cargo' : cargo
    };
  }

}