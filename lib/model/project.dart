
class Project {
  final String id;
  final String name;
  final String status;
  final String? qrcode;
  final String? genre;

  Project(this.id, this.name, this.status, this.qrcode, this.genre);

  Project.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
      name = json['name'] as String,
      status = json['status'] as String,
      qrcode = json['qrcode'] as String?,
      genre = json['genre'] as String?;


  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
      'status' : status,
      'qrcode' : qrcode,
      'genre' : genre
    };
  }

}