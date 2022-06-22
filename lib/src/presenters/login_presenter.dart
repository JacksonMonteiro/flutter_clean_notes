// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class LoginViewContract {
  start();
  loading();
  success();
  userError();
  passwordError();
  isLoadingChange();
}

class LoginPresenter {
  final _auth = FirebaseAuth.instance;

  bool result = false;
  bool isLoading = false;

  final state = ValueNotifier<LoginState>(LoginState.start);
  late final LoginViewContract contract;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginPresenter(this.contract);

  stateManagment(LoginState state) {
    switch (state) {
      case LoginState.start:
        return contract.start();
      case LoginState.loading:
        return contract.loading();
      case LoginState.userError:
        return contract.userError();
      case LoginState.passwordError:
        return contract.passwordError();
    }
  }

  login() async {
    state.value = LoginState.loading;
    isLoading = true;
    contract.isLoadingChange();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: usernameController.text, password: passwordController.text);

      if (userCredential != null) {
        isLoading = false;
        contract.isLoadingChange();
        contract.success();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        state.value = LoginState.userError;
      } else if (e.code == 'wrong-password') {
        state.value = LoginState.passwordError;
      }
    }
  }
}

enum LoginState { start, loading, userError, passwordError }
