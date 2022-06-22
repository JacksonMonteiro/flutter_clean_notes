// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/src/presenters/login_presenter.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> implements LoginViewContract {
  late LoginPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedBuilder(
            animation: presenter.state,
            builder: (context, child) =>
                presenter.stateManagment(presenter.state.value)));
  }

  @override
  initState() {
    super.initState();
    presenter = LoginPresenter(this);
  }

  @override
  start() {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'login.title'.tr(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                TextField(
                  controller: presenter.usernameController,
                  cursorColor: const Color(0xffaff7ad),
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffaff7ad)),
                      borderRadius: BorderRadius.all(Radius.circular(48)),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(48)),
                    ),
                    hintText: 'login.email'.tr(),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  cursorColor: const Color(0xffaff7ad),
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffaff7ad)),
                      borderRadius: BorderRadius.all(Radius.circular(48)),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(48)),
                    ),
                    hintText: 'login.password'.tr(),
                  ),
                  controller: presenter.passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    presenter.login();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text('login.login-btn'.tr(),
                            style: const TextStyle(
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
                    Navigator.of(context).pushNamed('/register');
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text('login.register-btn'.tr(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center),
                      )),
                ),
              ]),
        ),
      ),
    );
  }

  @override
  loading() {
    return Center(
        child: presenter.isLoading
            ? const CircularProgressIndicator()
            : Container());
  }

  @override
  isLoadingChange() {
    setState(() {});
  }

  @override
  userError() {
    return Container(
      color: Colors.black54,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: AlertDialog(
        title: Text('login.emailNotFound'.tr()),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
            ),
            onPressed: () {
              presenter.state.value = LoginState.start;
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
  passwordError() {
    return Container(
      color: Colors.black54,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: AlertDialog(
        title: Text('login.passwordError'.tr()),
        actions: <Widget>[
          TextButton(
            child: Text('login.try-again'.tr()),
            onPressed: () {
              presenter.state.value = LoginState.start;
            },
          ),
        ],
      ),
    );
  }

  @override
  success() {
    Navigator.of(context).pushReplacementNamed('/home');
  }
}
