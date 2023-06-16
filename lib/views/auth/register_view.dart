import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:my_notes/constants/routes.dart';

import '../../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController  _email;
  late final TextEditingController  _pass ;
  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Screen"),),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            decoration: const InputDecoration(
                hintText: "Enter your email"
            ),
          ),
          TextField(
            controller: _pass,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password",
              hintStyle: TextStyle(

              ),
            ),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final pass = _pass.text;
                try {
                  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: pass,
                  );
                  //we can directly go to verify screen as a newly registered user won't be verified
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on FirebaseAuthException catch (e) {
                  devtools.log(e.toString());
                  await showErrorDialog(context,e.code);
                } catch (e) {
                  devtools.log(e.toString());
                  await showErrorDialog(context, e.toString());
                }
              },
              child: const Text(
                "Register",
                style: TextStyle(
                    color: Colors.black
                ),
                textScaleFactor: 2,
              )
          ),
          TextButton(
              onPressed : (){
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Already a User? Login")),
        ],
      ),
    );
  }
}

