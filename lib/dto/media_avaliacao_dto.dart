
class MediaAvaliacaoDto {
  final int? gameplayMedia;
  final int? soundMedia;
  final int? storyMedia;
  final int? performaceMedia;
  final int? gameInterfaceMedia;
  final String projetoId;
  final List<String> comentarios;

  MediaAvaliacaoDto(this.projetoId, this.gameplayMedia, this.soundMedia, this.storyMedia, this.performaceMedia, this.gameInterfaceMedia, this.comentarios);


  MediaAvaliacaoDto.fromJson(Map<String, dynamic> json):
        projetoId = json['projetoId'] as String,
        gameplayMedia = json['gameplayMedia'] as int,
        soundMedia = json['soundMedia'] as int,
        storyMedia = json['storyMedia'] as int,
        performaceMedia = json['performaceMedia'] as int,
        gameInterfaceMedia = json['gameInterfaceMedia'] as int,
        comentarios = (json['comentarios'] as List<dynamic>).cast<String>();

}
