// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class NoteViewContract {
  start();
  loading();
  success();
  error();
  isLoadingChange();
  exit();
}

class NotePresenter {
  final auth = FirebaseAuth.instance;
  final CollectionReference noteRef =
      FirebaseFirestore.instance.collection('notes');

  bool result = false;
  bool isLoading = false;

  final state = ValueNotifier<NoteState>(NoteState.start);
  late final NoteViewContract contract;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  NotePresenter(this.contract);

  stateManagment(NoteState state) {
    switch (state) {
      case NoteState.start:
        return contract.start();
      case NoteState.loading:
        return contract.loading();
      case NoteState.error:
        return contract.error();
    }
  }

  add() async {
    state.value = NoteState.loading;
    isLoading = true;
    contract.isLoadingChange();

    String title = titleController.text;
    String note = contentController.text;
    DateTime date = DateTime.now();

    // User and UID
    User? user = auth.currentUser;
    final uid = user?.uid;

    titleController.text = '';
    contentController.text = '';

    try {
      await noteRef.add(
          {"title": title, "content": note, "date": date, "user_uid": uid});
      isLoading = false;
      contract.isLoadingChange();
      contract.success();
    } on FirebaseAuthException {
      state.value = NoteState.error;
    }
  }
}

enum NoteState { start, loading, error }
