class Tarefa {
  Tarefa({required this.titulo, required this.dataHora});
  Tarefa.fromJson(Map<String, dynamic> json)
      :titulo=json['titulo'],
  dataHora = DateTime.parse(json['dataHora']);

  DateTime dataHora;
  String titulo;

  Map<String, dynamic> toJson() {
    return {
      "titulo": titulo,
      "dataHora": dataHora.toIso8601String(),
    };
  }
}
