import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
                  if(credential.user?.emailVerified == false){
                    Navigator.of(context).pushNamedAndRemoveUntil('/verifyemail/', (route) => false);
                  }
                } on FirebaseAuthException catch (e) {
                  exceptionActions(e.code);
                } catch (e) {
                  print(e);
                }
              },
              child: const Text(
                "Register Button",
                style: TextStyle(
                    color: Colors.black
                ),
                textScaleFactor: 2,
              )
          ),
          TextButton(
              onPressed : (){
                Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
              },
              child: const Text("Already a User? Login")),
        ],
      ),
    );
  }
}

void exceptionActions(String code){
  if (code == 'weak-password') {
    print('The password provided is too weak, Please Provide a password of at least 6-characters.');
  } else if (code == 'email-already-in-use') {
    print('The account already exists for that email.');
  }
}