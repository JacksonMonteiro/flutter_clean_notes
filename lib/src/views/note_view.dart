// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NoteView extends StatefulWidget {
  final String id;

  const NoteView({Key? key, required this.id}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final CollectionReference _notes =
      FirebaseFirestore.instance.collection('notes');

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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

                      await _notes
                          .add({"title": title, "content": note, "date": date});

                      titleController.text = '';
                      noteController.text = '';

                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.check),
                    color: Colors.white,
                  ),
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
              decoration: const InputDecoration(
                hintText: 'Title',
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(
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
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write down your thoughts...',
                  hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white54,
                      fontWeight: FontWeight.normal)),
            )
          ]),
        ),
      ),
    );
  }
}
