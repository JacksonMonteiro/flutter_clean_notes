// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  final CollectionReference _noteRef =
      FirebaseFirestore.instance.collection('notes');

  late Query _notes;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    final uid = user?.uid;

    _notes = FirebaseFirestore.instance
        .collection('notes')
        .where('user_uid', isEqualTo: uid)
        .orderBy('date', descending: true);

    return Scaffold(
      body: StreamBuilder(
          stream: _notes.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return Column(
                children: [
                  const SizedBox(
                    height: 36,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PopupMenuButton(
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () async {
                                    await _auth.signOut().then((value) =>
                                        Navigator.of(context)
                                            .pushReplacementNamed('/'));
                                  },
                                  value: 0,
                                  child: Text(
                                    'home.exit'.tr(),
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: Text(
                                    'home.switch-lang'.tr(),
                                  ),
                                  onTap: () {
                                    Future.delayed(
                                      const Duration(seconds: 0),
                                      () => showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  Text("home.choose-lang".tr()),
                                              actions: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Column(children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .black),
                                                        ),
                                                        onPressed: () {
                                                          context.setLocale(
                                                              const Locale(
                                                                  'pt', 'BR'));
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            'home.ptBr'.tr(),
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xffaff7ad))),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .black),
                                                        ),
                                                        onPressed: () {
                                                          context.setLocale(
                                                              const Locale(
                                                                  'en', 'US'));
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            'home.enUs'.tr(),
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xffaff7ad))),
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ],
                                            );
                                          }),
                                    );
                                  },
                                ),
                              ])
                    ],
                  ),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];

                          var date = DateTime.fromMillisecondsSinceEpoch(
                              documentSnapshot['date'].seconds * 1000);

                          return GestureDetector(
                            onTap: () => _update(documentSnapshot),
                            child: Card(
                              margin: const EdgeInsets.all(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 24),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      documentSnapshot['title'],
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffaff7ad)),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      documentSnapshot['content'],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      "${date.day}/${date.month}/${date.year}",
                                      style: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/note');
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    titleController.text = documentSnapshot!['title'];
    noteController.text = documentSnapshot['content'];

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              String title = titleController.text;
                              String note = noteController.text;
                              DateTime date = DateTime.now();

                              await _noteRef.doc(documentSnapshot.id).update({
                                "title": title,
                                "content": note,
                                "date": date
                              });

                              titleController.text = '';
                              noteController.text = '';

                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.edit),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _noteRef.doc(documentSnapshot.id).delete();
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                TextField(
                  autofocus: true,
                  cursorColor: const Color(0xFFaff7ad),
                  style: const TextStyle(
                      color: Color(0xffaff7ad),
                      fontSize: 24,
                      fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                    hintText: 'note.title'.tr(),
                    border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70)),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70)),
                    hintStyle: const TextStyle(
                      fontSize: 24,
                      color: Colors.white54,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  controller: titleController,
                ),
                TextField(
                  controller: noteController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'notes.message'.tr(),
                      hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white54,
                          fontWeight: FontWeight.normal)),
                )
              ]),
            ),
          );
        });
  }
}
