import 'package:espaco_cafe_restaurante/route_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  _autenticarUsuario() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    bool ehEmailValido = _validarEmail(email);

    if (!ehEmailValido) {
      var snackBar = _construirSnackBar("Email informado é inválido", true);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (senha.isEmpty) {
      var snackBar = _construirSnackBar("A senha deve ser informada", true);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    FirebaseAuth autenticador = FirebaseAuth.instance;
    autenticador.signInWithEmailAndPassword(email: email, password: senha)
        .then((firebaseUser) {
          Navigator.pushReplacementNamed(context, RouteGenerator.LISTA_COMRPAS);
        }).catchError((error) {
          var snackBar = _construirSnackBar("Erro ao autenticar. Verifique email e senha.", true);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
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

  bool _validarEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  _verificarAutenticacao() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    if (usuarioLogado != null) {
      Navigator.pushReplacementNamed(context, RouteGenerator.LISTA_COMRPAS);
    }
  }

  @override
  void initState() {
    _verificarAutenticacao();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
                opacity: 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 13),
                  child: Image.asset(
                    'images/login_background.png',
                    fit: BoxFit.cover,
                  ),
                )),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 80, 10, 30),
                  child: Image.asset("images/logo_horizontal.png"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 16),
                  child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffD6B9AC).withOpacity(0.58),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            color: const Color(0xffD6B9AC), width: 1.0),
                      ),
                      // height: 350,
                      width: double.infinity,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
                            child: Text(
                              "FAÇA SEU LOGIN",
                              style: TextStyle(
                                  color: Color(0xff743C29),
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: TextField(
                              controller: _controllerEmail,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                  fontSize: 16, color: Color(0xff743C29)),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                hintText: "E-mail",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: TextField(
                              obscureText: true,
                              controller: _controllerSenha,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                  fontSize: 16, color: Color(0xff743C29)),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                hintText: "Senha",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 20),
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              child: const Text(
                                "Esqueci minha senha",
                                style: TextStyle(color: Color(0xff743C29)),
                              ),
                              onTap: () {

                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30, bottom: 30, right: 20, left: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  _autenticarUsuario();
                                },
                                child: const Text(
                                  "Entrar",
                                  style: TextStyle(color: Color(0xff743C29), fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
