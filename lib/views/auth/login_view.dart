import 'package:flutter/material.dart';
//firebase
import 'dart:developer' as devtools show log;

import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import '../../services/auth/auth_exceptions.dart';
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
                  await AuthService.fromFirebase().logIn(email: email, password: pass);
                  final user = AuthService.fromFirebase().currentUser;
                  if(user != null && user.isEmailVerified == false){
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  }
                  else if(user?.isEmailVerified ?? false){
                    Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  }
                } on UserNotFoundAuthException {
                    await showErrorDialog(context, 'User Not Found');
                } on WrongPasswordAuthException{
                    await showErrorDialog(context, 'Wrong Credentials');
                } on GenericAuthException{
                  await showErrorDialog(context, 'Authentication Error');
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




// new 100 lines of code
//......
