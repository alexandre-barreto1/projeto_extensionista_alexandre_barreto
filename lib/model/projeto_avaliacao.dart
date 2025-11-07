
class ProjetoAvaliacao {
    final int? gameplay;
    final int? sound;
    final int? story;
    final int? performace;
    final int? gameInterface;
    final String? comentario;
    final String projetoId;

    ProjetoAvaliacao(this.projetoId, this.gameplay, this.sound, this.story, this.performace, this.gameInterface, this.comentario);


    ProjetoAvaliacao.fromJson(Map<String, dynamic> json):
        projetoId = json['projetoId'] as String,
        gameplay = json['gameplay'] as int,
        sound = json['sound'] as int,
        story = json['story'] as int,
        performace = json['performace'] as int,
        gameInterface = json['gameInterface'] as int,
        comentario = json['comentario'] as String;

    Map<String, dynamic> toJson() {
      return {
        'gameplay': gameplay,
        'sound': sound,
        'story': story,
        'performace': performace,
        'gameInterface': gameInterface,
        'comentario': comentario,
        'projetoId': projetoId,
      };
    }

}
