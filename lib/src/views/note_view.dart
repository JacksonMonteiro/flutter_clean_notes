import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(children: const [
            TextField(
              autofocus: true,
              cursorColor: Colors.white,
              style: TextStyle(
                  color: Color(0xffaff7ad),
                  fontSize: 24,
                  fontWeight: FontWeight.normal),
              decoration: InputDecoration(
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
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
