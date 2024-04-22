class Fornecedor {

  late String _id;
  late String _nome;
  late String _telefone;
  late String _email;

  Fornecedor();

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  Map<String, dynamic> toMap() {
    return {
      "nome" : nome,
      "telefone" : telefone,
      "email" : email
    };
  }
}