import 'package:flutter/material.dart';
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
    bool _visibility = false;
    final state = context.read<AuthBloc>().state;
    if(state is AuthStateLoggedOut){
      if(state.isLoading == true)
        _visibility = true;
    }

    return BlocConsumer<AuthBloc , AuthState>(
      listener: (context , state) async{

        if(state is AuthStateLoggedOut){
          _visibility = true;
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
      builder: (context , state){
        if(state is AuthStateLoggedOut && state.isLoading == true){
          _visibility = true;
        }
        else _visibility = false;
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
              TextButton(                            //the listener belongs the text button, so it will only listen to changes that pressing the button produces
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
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventNavigateToRegister());
                  },
                  child: const Text('New User? Register')
              ),
              Center(
                child: Visibility(
                    visible: _visibility,
                    child: CircularProgressIndicator()),
              )
            ],
          ),
        );
      },

    );
  }
}




// new 100 lines of code
//......
