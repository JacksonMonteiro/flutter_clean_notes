// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/src/presenters/login_presenter.dart';

abstract class RegisterViewContract {
  start();
  loading();
  success();
  emailExistsError();
  passwordError();
  isLoadingChange();
}

class RegisterPresenter {
  final _auth = FirebaseAuth.instance;

  bool result = false;
  bool isLoading = false;

  final state = ValueNotifier<RegisterState>(RegisterState.start);
  late final RegisterViewContract contract;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RegisterPresenter(this.contract);

  stateManagment(RegisterState state) {
    switch (state) {
      case RegisterState.start:
        return contract.start();
      case RegisterState.loading:
        return contract.loading();
      case RegisterState.emailExistsError:
        return contract.emailExistsError();
      case RegisterState.passwordError:
        return contract.passwordError();
    }
  }

  register() async {
    state.value = RegisterState.loading;
    isLoading = true;
    contract.isLoadingChange();

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      if (userCredential != null) {
        isLoading = false;
        contract.isLoadingChange();
        contract.success();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        state.value = RegisterState.passwordError;
      } else if (e.code == 'email-already-in-use') {
        state.value = RegisterState.emailExistsError;
      }
    }
  }
}

enum RegisterState { start, loading, passwordError, emailExistsError }
