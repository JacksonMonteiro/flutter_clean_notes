// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/src/presenters/note_presenter.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> implements NoteViewContract {
  late NotePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
          animation: _presenter.state,
          builder: (context, child) =>
              _presenter.stateManagment(_presenter.state.value)),
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

  @override
  initState() {
    super.initState();
    _presenter = NotePresenter(this);
  }

  @override
  start() {
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () async {
                    _presenter.add();
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
            controller: _presenter.titleController,
          ),
          TextField(
            controller: _presenter.contentController,
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
                hintText: 'note.message'.tr(),
                hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.white54,
                    fontWeight: FontWeight.normal)),
          )
        ]),
      ),
    );
  }

  @override
  loading() {
    return Center(
        child: _presenter.isLoading
            ? const CircularProgressIndicator()
            : Container());
  }

  @override
  isLoadingChange() {
    setState(() {});
  }

  @override
  success() {
    Navigator.of(context).pop();
  }

  @override
  error() {
    return Container(
      color: Colors.black54,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: AlertDialog(
        title: Text('note.error'.tr()),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
            ),
            onPressed: () {
              _presenter.state.value = NoteState.start;
            },
            child: Text('login.try-again'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }

  @override
  exit() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}
