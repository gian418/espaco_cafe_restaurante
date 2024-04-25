import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espaco_cafe_restaurante/app_bar_default.dart';
import 'package:espaco_cafe_restaurante/model/fornecedor.dart';
import 'package:flutter/material.dart';

class Fornecedores extends StatefulWidget {
  const Fornecedores({super.key});

  @override
  State<Fornecedores> createState() => _FornecedoresState();
}

class _FornecedoresState extends State<Fornecedores> {

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  late Stream<List<Fornecedor>> _streamFornecedores;

  Widget criarItemStreamBuilder(context, indice, Fornecedor fornecedor) {
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
            title:Text(
              fornecedor.nome,
              style: const TextStyle(
                  color: Color.fromRGBO(116, 60, 41, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fornecedor.telefone,
                  style: const TextStyle(
                    color: Color.fromRGBO(116, 60, 41, 1),
                    fontSize: 14,
                  ),
                ),
                Text(
                  fornecedor.email,
                  style: const TextStyle(
                    color: Color.fromRGBO(116, 60, 41, 1),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          onTap: () {
              _exibirTelaCadastro(fornecedor: fornecedor);
          },
        ),
      ),
    );
  }

  _exibirTelaCadastro({Fornecedor? fornecedor}) {

    String textoSalvarAtualizar = "";
    if (fornecedor == null) {
      _nomeController.clear();
      _telefoneController.clear();
      _emailController.clear();
      textoSalvarAtualizar =  "Salvar";
    } else {
      _nomeController.text = fornecedor.nome;
      _telefoneController.text = fornecedor.telefone;
      _emailController.text = fornecedor.email;
      textoSalvarAtualizar =  "Atualizar";
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
            "$textoSalvarAtualizar Fornecedor",
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
                      hintText: "Digite o nome do fornecedor",
                  ),
                ),
                TextField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Telefone",
                      hintText: "Digite apenas os números"
                  ),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Digite o email do fornecedor"
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
                    _salvarFornecedor(fornecedor?.id);
                    Navigator.pop(context);
                  },
                  child: Text(textoSalvarAtualizar, style: const TextStyle(color: Color.fromRGBO(116, 60, 41, 1)))
              ),
            ],
          );
        },
    );
  }

  _salvarFornecedor(String? fornecedorId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String nome = _nomeController.text;
    String telefone = _telefoneController.text;
    String email = _emailController.text;

    Fornecedor fornecedor = Fornecedor();
    fornecedor.nome = nome;
    fornecedor.telefone = telefone;
    fornecedor.email = email;

    if (fornecedorId == null) {
      firestore.collection("Fornecedores").add(fornecedor.toMap()).then((_) {
        var snackBar = _construirSnackBar("Fornecedor adicionado com sucesso", false);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      firestore.collection("Fornecedores").doc(fornecedorId).set(fornecedor.toMap()).then((_) {
        var snackBar = _construirSnackBar("Fornecedor atualizado com sucesso", false);
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

  Stream<List<Fornecedor>> _carregarFornecedores() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection("Fornecedores")
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        var fornecedor = Fornecedor();
        fornecedor.id = doc.id;
        fornecedor.nome = doc.get("nome");
        fornecedor.telefone = doc.get("telefone");
        fornecedor.email = doc.get("email");
        return fornecedor;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _streamFornecedores = _carregarFornecedores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault.build(),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              width: double.infinity,
              color: const Color.fromRGBO(214, 185, 172, 0.41),
              child: const Text(
                "Fornecedores",
                style: TextStyle(
                    color: Color.fromRGBO(116, 60, 41, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            Expanded(
                child: StreamBuilder<List<Fornecedor>>(
                  stream: _streamFornecedores,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Center(
                          child: Column(
                            children: [
                              Text("Carregando fornecedores"),
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
                              List<Fornecedor> listas = snapshot.data!;
                              Fornecedor fornecedor = listas[indice];
                              return criarItemStreamBuilder(
                                  context, indice, fornecedor);
                            },
                          );
                        } else {
                          return const Center(
                            child: Text("Nenhum fornecedor encontrado."),
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
