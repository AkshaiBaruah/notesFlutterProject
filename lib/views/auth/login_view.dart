import 'package:flutter/material.dart';
//firebase
import 'dart:developer' as devtools show log;

import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/bloc/auth_bloc.dart';
import 'package:my_notes/services/bloc/auth_events.dart';
import 'package:my_notes/services/bloc/auth_states.dart';
import '../../services/auth/auth_exceptions.dart';
import '../../utilities/Dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



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
          BlocListener<AuthBloc , AuthState>(             //listens to changes in the state and produce a side effect
            listener: (context , state)  async{
              if(state is AuthStateLoggedOut){
                final exception = state.exception;
                if(exception is UserNotFoundAuthException){
                  await showErrorDialog(context, "User Not Found");
                }else if(exception is WrongPasswordAuthException){
                  await showErrorDialog(context, 'Wrong Credentials..');
                } else if(exception is GenericAuthException){
                  await showErrorDialog(context, 'Auth Error');
                }
              }
            },
            child: TextButton(                            //the listener belongs the text button, so it will only listen to changes that pressing the button produces
                onPressed: () async {
                  final email = _email.text;
                  final pass = _pass.text;
                  context.read<AuthBloc>().add(
                      AuthEventLogIn(email: email, password: pass)
                  );       //add login event on button press

                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.black
                  ),
                  textScaleFactor: 2,
                )
            ),
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
