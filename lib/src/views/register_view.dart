// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/src/presenters/register_presenter.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    implements RegisterViewContract {
  late RegisterPresenter presenter;

  // Validation variables
  final _emailText = null;
  final _passwordText = null;
  bool isValid = false;

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
    presenter = RegisterPresenter(this);
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
                  'register.title'.tr(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                TextField(
                  controller: presenter.emailController,
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
                    errorText: _emailErrorText,
                  ),
                  onChanged: (text) => setState(() => _emailText),
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
                    errorText: _passwordErrorText,
                  ),
                  controller: presenter.passwordController,
                  obscureText: true,
                  onChanged: (text) => setState(() => _passwordText),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (presenter.emailController.text.isNotEmpty &&
                        presenter.passwordController.text.isNotEmpty &&
                        isValid) {
                      presenter.register();
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text('login.register-btn'.tr(),
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
                    Navigator.of(context).pop();
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
                        child: Text('register.back-btn'.tr(),
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

  String? get _emailErrorText {
    final text = presenter.emailController.text;

    if (text.isEmpty) {
      return 'login.emptyEmail'.tr();
    }

    if (!text.contains('@')) {
      return 'login.invalidEmail'.tr();
    }

    isValid = true;
    return null;
  }

  String? get _passwordErrorText {
    final text = presenter.passwordController.text;

    if (text.isEmpty) {
      return 'login.emptyPassword'.tr();
    }

    isValid = true;
    return null;
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
  emailExistsError() {
    return Container(
      color: Colors.black54,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: AlertDialog(
        title: Text('register.emailExists'.tr()),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
            ),
            onPressed: () {
              presenter.state.value = RegisterState.start;
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
        title: Text('register.weakPassword'.tr()),
        actions: <Widget>[
          TextButton(
            child: Text('login.try-again'.tr()),
            onPressed: () {
              presenter.state.value = RegisterState.start;
            },
          ),
        ],
      ),
    );
  }

  @override
  success() {
    Navigator.of(context).pop();
  }
}
