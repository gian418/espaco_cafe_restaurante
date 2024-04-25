class Produto {

  late String _id;
  late String nome;

  Produto();

  Map<String, dynamic> toMap() {
    return {
      "nome" : nome
    };
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}