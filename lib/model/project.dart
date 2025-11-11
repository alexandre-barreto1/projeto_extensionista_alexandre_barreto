
import 'package:projeto_extensionista_alexandre_barreto/model/projeto_data.dart';

class Project {
  final String id;
  final String name;
  final String status;
  final String? qrcode;
  final String? genero;
  final String? imagemprincipal;
  final ProjectData? projetoData;

  Project(this.id, this.name, this.status, this.qrcode, this.genero, this.imagemprincipal, this.projetoData);

  Project.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
      name = json['name'] as String,
      status = json['status'] as String,
      qrcode = json['qrcode'] as String?,
      genero = json['genero'] as String?,
      imagemprincipal = json['imagemprincipal'] as String?,
      projetoData = json['projetoData'];


  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
      'status' : status,
      'qrcode' : qrcode,
      'genero' : genero,
      'imagemprincipal': imagemprincipal,
      'projetoData': projetoData
    };
  }

}