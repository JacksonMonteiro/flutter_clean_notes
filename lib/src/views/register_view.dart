import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/src/views/note_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Olá! Vejo que é novo por aqui. Para usar o App, basta criar uma conta, e pronto, já poderá começar a registrar seus pensamentos de maneira simples',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  TextField(
                    controller: usernameController,
                    cursorColor: const Color(0xffaff7ad),
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffaff7ad)),
                        borderRadius: BorderRadius.all(Radius.circular(48)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(48)),
                      ),
                      hintText: 'E-mail',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    cursorColor: const Color(0xffaff7ad),
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffaff7ad)),
                        borderRadius: BorderRadius.all(Radius.circular(48)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(48)),
                      ),
                      hintText: 'Senha',
                    ),
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      register();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Criar conta',
                              style: TextStyle(
                                color: Color(0xffaff7ad),
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center),
                        )),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.white,
                      ),
                      side: MaterialStateProperty.all(
                        const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Voltar',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center),
                        )),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: usernameController.text,
              password: passwordController.text);

      if (userCredential != null) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Senha fraca, por favor, crie uma senha mais forte'),
              backgroundColor: Colors.redAccent),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('O E-mail já está sendo utilizado por outro usuário'),
              backgroundColor: Colors.redAccent),
        );
      }
    }
  }
}
