
class MediaAvaliacaoDto {
  final int? gameplay;
  final int? sound;
  final int? story;
  final int? performace;
  final int? gameInterface;
  final String projetoId;
  final List<String> comentarios;

  MediaAvaliacaoDto(this.projetoId, this.gameplay, this.sound, this.story, this.performace, this.gameInterface, this.comentarios);


  MediaAvaliacaoDto.fromJson(Map<String, dynamic> json):
        projetoId = json['projetoId'] as String,
        gameplay = json['gameplay'] as int,
        sound = json['sound'] as int,
        story = json['story'] as int,
        performace = json['performace'] as int,
        gameInterface = json['gameInterface'] as int,
        comentarios = json['comentarios'] as List<String>;

}
