import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espaco_cafe_restaurante/app_bar_default.dart';
import 'package:espaco_cafe_restaurante/model/ProdutoLista.dart';
import 'package:espaco_cafe_restaurante/model/produto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CadastroListaCompra extends StatefulWidget {
  const CadastroListaCompra({super.key});

  @override
  State<CadastroListaCompra> createState() => _CadastroListaCompraState();
}

class _CadastroListaCompraState extends State<CadastroListaCompra> {
  List<Produto> _produtosEncontrados = [];
  List<ProdutoLista> _produtosSelecionados = [];
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _nomeProdutoController = TextEditingController();
  late String _fornecedorSelecionado;
  List<String> _fornecedores = [];

  void adicionarProdutoSelecionado(Produto produto) {
    setState(() {
      ProdutoLista produtoLista = ProdutoLista();
      produtoLista.nome = produto.nome;
      _produtosSelecionados.add(produtoLista);
    });
  }

  _exibirTelaBuscarProdutos() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Buscar Produto",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    TextField(
                      controller: _nomeProdutoController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: "Produto",
                        hintText: "Digite o nome do produto",
                      ),
                      onEditingComplete: () async {
                        List<Produto> produtosEncontrados =
                            await _buscarProdutos(_nomeProdutoController.text);
                        setState(() {
                          _produtosEncontrados.clear();
                          _produtosEncontrados.addAll(produtosEncontrados);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _produtosEncontrados.length,
                      itemBuilder: (context, index) {
                        Produto produto = _produtosEncontrados[index];
                        return ListTile(
                          title: Text(produto.nome),
                          onTap: () {
                            adicionarProdutoSelecionado(produto);
                            _produtosEncontrados.clear();
                            _nomeProdutoController.clear();
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Produto>> _buscarProdutos(String nomeProduto) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var querySnapshot = await firestore
        .collection("Produtos")
        .where("nome", isGreaterThanOrEqualTo: nomeProduto)
        .where("nome", isLessThan: nomeProduto + 'z')
        .get();

    List<Produto> produtos = [];
    for (DocumentSnapshot item in querySnapshot.docs) {
      Produto produto = Produto();
      produto.nome = item["nome"];
      produtos.add(produto);
      print("Produto encontrado ${produto.nome}");
    }

    return produtos;
  }

  Future<List<String>> _buscarFornecedores() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection("Fornecedores").get();

    List<String> fornecedores = [];
    for (DocumentSnapshot fornecedor in querySnapshot.docs) {
      fornecedores.add(fornecedor["nome"]);
    }

    return fornecedores;
  }

  @override
  void initState() {
    super.initState();
    _buscarFornecedores().then((fornecedores) {
      setState(() {
        _fornecedores = fornecedores;
        _fornecedorSelecionado = (fornecedores.isNotEmpty ? fornecedores[0] : null)!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault.build(),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              width: double.infinity,
              color: const Color.fromRGBO(214, 185, 172, 0.41),
              child: const Text(
                "Nova Lista de Compras",
                style: TextStyle(
                    color: Color.fromRGBO(116, 60, 41, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _descricaoController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Nome",
                  hintText: "Digite uma descricão",
                  contentPadding:
                  const EdgeInsets.fromLTRB(8, 6, 8, 6),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
              child: DropdownButtonFormField<String>(
                value: _fornecedorSelecionado,
                items: _fornecedores.map((String fornecedor) {
                  return DropdownMenuItem<String>(
                    value: fornecedor,
                    child: Text(fornecedor),
                  );
                }).toList(),
                onChanged: (String? novoFornecedor) {
                  setState(() {
                    _fornecedorSelecionado = novoFornecedor!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Fornecedor',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Produtos selecionados",
                    style: TextStyle(
                        color: Color.fromRGBO(116, 60, 41, 1), fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _exibirTelaBuscarProdutos();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffD6B9AC),
                        surfaceTintColor: Colors.white),
                    child: const Icon(Icons.search,
                        color: Color.fromRGBO(116, 60, 41, 1)),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _produtosSelecionados.length,
                  itemBuilder: (context, index) {
                    ProdutoLista produto = _produtosSelecionados[index];
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(produto.nome),
                            ),
                            SizedBox(
                              width: 60,
                              child: TextField(
                                controller: produto.quantidadeController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Qtd.',
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(8, 6, 8, 6),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onChanged: (value) {
                                  int quantidade = int.tryParse(value) ?? 0;
                                  setState(() {
                                    produto.quantidade = quantidade;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
