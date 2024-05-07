import 'package:espaco_cafe_restaurante/model/produto_lista.dart';

class ListasCompra {

  late String _id;
  late String _data;
  late String _descricao;
  late String _status;
  late String _fornecedor;
  late List<ProdutoLista> _produtos;

  ListasCompra(){}

  Map<String, dynamic> toMap() {
    return {
      "dataCriacao" : data,
      "descricao" : descricao,
      "status" : status,
      "fornecedor" : fornecedor,
      "produtos" : produtos.map((p) => p.toMap()).toList()
    };
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get descricao => _descricao;

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  set descricao(String value) {
    _descricao = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  List<ProdutoLista> get produtos => _produtos;

  set produtos(List<ProdutoLista> value) {
    _produtos = value;
  }

  String get fornecedor => _fornecedor;

  set fornecedor(String value) {
    _fornecedor = value;
  }
}