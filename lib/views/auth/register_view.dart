
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/services/bloc/auth_events.dart';
import 'package:my_notes/services/bloc/auth_states.dart';
import '../../services/auth/auth_exceptions.dart';
import '../../services/bloc/auth_bloc.dart';
import '../../utilities/Dialogs/error_dialog.dart';


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
    return BlocConsumer<AuthBloc , AuthState>(        //listener of the register screen to listen to changes
      listener: (context , state){
        if(state is AuthStateRegisterScreen){
          if(state.isLoading == true){

          }
          final exception = state.exception;
          if (exception is InvalidEmailAuthException){
            showErrorDialog(context, 'Invalid Email');
          }else if(exception is WeakPasswordAuthException){
            showErrorDialog(context, 'Please Use a strong password of 6 characters.');
          }else if(exception is EmailAlreadyInUseAuthException){
              showErrorDialog(context, 'Email is already in use.');
          }
          else if(exception is GenericAuthException){
            showErrorDialog(context, 'Authentication Error');
          }

        }
      },

      builder:(context , state) => Scaffold(
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
                  context.read<AuthBloc>().add(AuthEventRegister(email: email, password: pass));

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
                  context.read<AuthBloc>().add(AuthEventLogOut());
                },
                child: const Text("Already a User? Login")
            ),
            Center(
              child: Visibility(
                visible: (state as AuthStateRegisterScreen).isLoading,
                child:const  CircularProgressIndicator(color: Colors.black45,),
              ),
            )
          ],
        ),
      ),
    );
  }
}

