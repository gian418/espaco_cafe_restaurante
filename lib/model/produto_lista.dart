import 'package:flutter/cupertino.dart';

class ProdutoLista {

  late String nome;
  late int quantidade;
  late TextEditingController quantidadeController;

  ProdutoLista() {
    quantidade = 1;
    quantidadeController = TextEditingController(text: quantidade.toString());
  }

  Map<String, dynamic> toMap() {
    return {
      "nome" : nome,
      "quantidade" : quantidade
    };
  }

}