import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/src/views/note_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  final CollectionReference _noteRef =
      FirebaseFirestore.instance.collection('notes');
  final Query _notes = FirebaseFirestore.instance
      .collection('notes')
      .orderBy('date', descending: true);

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
                    'Seja bem-vindo(a) ao Clean Notes. Insira seus dados para continuar',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  const TextField(
                    cursorColor: Color(0xffaff7ad),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffaff7ad)),
                        borderRadius: BorderRadius.all(Radius.circular(48)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(48)),
                      ),
                      hintText: 'Nome de usuário',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const TextField(
                    cursorColor: Color(0xffaff7ad),
                    decoration: InputDecoration(
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
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Login',
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
                    onPressed: () {},
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
                          child: Text('Criar conta',
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
}
