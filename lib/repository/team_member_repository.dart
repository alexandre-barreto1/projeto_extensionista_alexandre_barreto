import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/team_member.dart';

/// adicionar esse repository no main()
class TeamMemberRepository extends ChangeNotifier {
  List<TeamMember> _list =[];

  static var teste = FirebaseFirestore.instance;

  UnmodifiableListView<TeamMember> get lista => UnmodifiableListView(_list);

  saveAll(List<TeamMember> teamMember) {
    teamMember.forEach((teamMember) {
      if(!_list.contains(teamMember)) _list.add(teamMember);
    });
    notifyListeners();
  }

  remove(TeamMember teamMember) {
    _list.remove(teamMember);
  }
}