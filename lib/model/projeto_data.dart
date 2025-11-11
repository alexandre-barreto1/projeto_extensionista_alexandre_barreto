
class ProjectData {
  final String id;
  final String? imagem1;
  final String? imagem2;
  final String projetoId;

  ProjectData(this.id, this.imagem1, this.imagem2, this.projetoId);

  ProjectData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        imagem1 = json['imagem1'] as String,
        imagem2 = json['imagem2'] as String,
        projetoId = json['projetoId'] as String;


  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'imagem1' : imagem1,
      'imagem2' : imagem2,
      'projetoId' : projetoId
    };
  }

}
