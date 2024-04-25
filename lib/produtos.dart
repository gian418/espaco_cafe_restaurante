import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espaco_cafe_restaurante/app_bar_default.dart';
import 'package:espaco_cafe_restaurante/model/produto.dart';
import 'package:flutter/material.dart';

class Produtos extends StatefulWidget {
  const Produtos({super.key});

  @override
  State<Produtos> createState() => _ProdutosState();
}

class _ProdutosState extends State<Produtos> {
  TextEditingController _nomeController = TextEditingController();
  late Stream<List<Produto>> _streamProdutos;

  Widget criarItemStreamBuilder(context, indice, Produto produto) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xffD6B9AC),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Card(
        color: const Color(0xffD6B9AC),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(
            produto.nome,
            style: const TextStyle(
                color: Color.fromRGBO(116, 60, 41, 1),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          onTap: () {
            _exibirTelaCadastro(produto: produto);
          },
        ),
      ),
    );
  }

  _exibirTelaCadastro({Produto? produto}) {
    String textoSalvarAtualizar = "";
    if (produto == null) {
      _nomeController.clear();
      textoSalvarAtualizar =  "Salvar";
    } else {
      _nomeController.text = produto.nome;
      textoSalvarAtualizar =  "Atualizar";
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "$textoSalvarAtualizar Produto",
            style: const TextStyle(
                color: Color.fromRGBO(116, 60, 41, 1),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  hintText: "Digite o nome do produto",
                ),
              ),
            ],
          ),
          actions:  [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar", style: TextStyle(color: Color.fromRGBO(116, 60, 41, 1)),)
            ),
            TextButton(
                onPressed: () {
                  _salvarProduto(produto?.id);
                  Navigator.pop(context);
                },
                child: Text(textoSalvarAtualizar, style: const TextStyle(color: Color.fromRGBO(116, 60, 41, 1)))
            ),
          ],
        );
      },
    );
  }

  _salvarProduto(String? produtoId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String nome = _nomeController.text;

    Produto produto = Produto();
    produto.nome = nome;

    if (produtoId == null) {
      firestore.collection("Produtos").add(produto.toMap()).then((_) {
        var snackBar = _construirSnackBar("Produto adicionado com sucesso", false);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      firestore.collection("Produtos").doc(produtoId).set(produto.toMap()).then((_) {
        var snackBar = _construirSnackBar("Produto atualizado com sucesso", false);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  SnackBar _construirSnackBar(String msg, ehErro) {
    return SnackBar(
      content: Text(
        msg,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
      backgroundColor: ehErro ? Colors.red : Colors.green,
      duration: const Duration(seconds: 6),
    );
  }

  Stream<List<Produto>> _carregarProdutos() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection("Produtos").snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        var produto = Produto();
        produto.id = doc.id;
        produto.nome = doc.get("nome");
        return produto;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _streamProdutos = _carregarProdutos();
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
                "Produtos",
                style: TextStyle(
                    color: Color.fromRGBO(116, 60, 41, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            Expanded(
              child: StreamBuilder<List<Produto>>(
                stream: _streamProdutos,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(
                        child: Column(
                          children: [
                            Text("Carregando produtos"),
                            CircularProgressIndicator()
                          ],
                        ),
                      );
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, indice) {
                            List<Produto> produtos = snapshot.data!;
                            Produto produto = produtos[indice];
                            return criarItemStreamBuilder(
                                context, indice, produto);
                          },
                        );
                      } else {
                        return const Center(
                          child: Text("Nenhum produto encontrado."),
                        );
                      }
                      break;
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
          _exibirTelaCadastro();
        },
        backgroundColor: const Color(0xffD6B9AC),
        foregroundColor: const Color(0xff743C29),
        child: const Icon(Icons.add),
      ),
    );
  }
}
