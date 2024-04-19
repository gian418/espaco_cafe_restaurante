class ListasCompra {

  late String _data;
  late String _descricao;
  late String _status;

  ListasCompra(){}

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


}