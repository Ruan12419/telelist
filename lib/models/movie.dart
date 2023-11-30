class Movie {
  final String uuid;
  final int usuario;
  final String titulo;
  final String descricao;
  final String linkImagem;
  final String dataDeLancamento;
  final String diretores;
  final String roteiristas;
  final String atores;
  final String generos;
  final String comentarios;
  final double estrelas;
  bool favorito;
  final String status;

  Movie({
    required this.uuid,
    required this.usuario,
    required this.titulo,
    required this.descricao,
    required this.linkImagem,
    required this.dataDeLancamento,
    required this.diretores,
    required this.roteiristas,
    required this.atores,
    required this.generos,
    required this.comentarios,
    required this.estrelas,
    required this.favorito,
    required this.status,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      uuid: json['uuid'],
      usuario: json['usuario'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      linkImagem: json['link_imagem'],
      dataDeLancamento: json['data_de_lancamento'],
      diretores: json['diretores'],
      roteiristas: json['roteiristas'],
      atores: json['atores'],
      generos: json['generos'],
      comentarios: json['comentarios'],
      estrelas: json['estrelas'],
      favorito: json['favorito'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'usuario': usuario,
      'titulo': titulo,
      'descricao': descricao,
      'link_imagem': linkImagem,
      'data_de_lancamento': dataDeLancamento,
      'diretores': diretores,
      'roteiristas': roteiristas,
      'atores': atores,
      'generos': generos,
      'comentarios': comentarios,
      'estrelas': estrelas,
      'favorito': favorito,
      'status': status,
    };
  }
}
