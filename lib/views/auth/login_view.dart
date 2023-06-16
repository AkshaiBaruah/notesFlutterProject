import 'package:flutter/material.dart';
//firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:my_notes/constants/routes.dart';

import '../../utilities/show_error_dialog.dart';


class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: const Text("Login Screen"),),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
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
                  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: pass
                  );
                  if(credential.user != null && credential.user?.emailVerified == false){
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  }
                  else if(credential.user?.emailVerified ?? false){
                    Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  }
                } on FirebaseAuthException catch (e)  {
                  devtools.log('Firebase auth exception occured');
                  await showErrorDialog(context, e.code);
                } catch (e){
                  await showErrorDialog(context, e.toString());
                }
              },
              child: const Text(
                "Login",
                style: TextStyle(
                    color: Colors.black
                ),
                textScaleFactor: 2,
              )
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('New User? Register'))
        ],
      ),
    );
  }
}

Future<void> showLoginErrorDialog(BuildContext context , String text,){
  return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Oops! An error occured'),
          content: Text(text),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'))
          ],
        );
      }
  );
}