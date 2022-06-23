// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class HomeViewContract {
  start();
  loading();
  success();
  error();
  isLoadingChange();
  exit();
}

class HomePresenter {
  final auth = FirebaseAuth.instance;
  final CollectionReference noteRef =
      FirebaseFirestore.instance.collection('notes');
  late Query notes;

  bool result = false;
  bool isLoading = false;

  final state = ValueNotifier<HomeState>(HomeState.start);
  late final HomeViewContract contract;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  HomePresenter(this.contract);

  stateManagment(HomeState state) {
    switch (state) {
      case HomeState.start:
        return contract.start();
      case HomeState.loading:
        return contract.loading();
      case HomeState.error:
        return contract.error();
    }
  }

  update([DocumentSnapshot? documentSnapshot]) async {
    state.value = HomeState.loading;
    isLoading = true;
    contract.isLoadingChange();

    titleController.text = documentSnapshot!['title'];
    contentController.text = documentSnapshot['content'];

    String title = titleController.text;
    String note = contentController.text;
    DateTime date = DateTime.now();

    try {
      await noteRef
          .doc(documentSnapshot.id)
          .update({"title": title, "content": note, "date": date});

      isLoading = false;
      contract.isLoadingChange();
      contract.success();
    } on FirebaseAuthException {
      state.value = HomeState.error;
    }
  }

  getUserUid() {
    User? user = auth.currentUser;
    final uid = user?.uid;
    return uid;
  }

  signOut() async {
    await auth.signOut().then((value) {
      contract.exit();
    });
  }
}

enum HomeState { start, loading, error }
