import 'package:flutter/material.dart';
//firebase
import 'package:firebase_auth/firebase_auth.dart';



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
                  if(credential.user != null && credential.user?.emailVerified == false)
                    Navigator.of(context).pushNamedAndRemoveUntil('/verifyemail/', (route) => false);

                } on FirebaseAuthException catch (e) {
                  print("firebase auth exception");
                    exceptionActions(e.code);
                }
                //check the user after login
                final user = FirebaseAuth.instance.currentUser;
                if(user?.emailVerified ?? false){
                  Navigator.of(context).pushNamedAndRemoveUntil('/notes/', (route) => false);
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
                Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
              },
              child: const Text('New User? Register'))
        ],
      ),
    );
  }
}

void exceptionActions(String code){
  if (code == 'user-not-found') {
    print('No user found for that email.');
  } else if (code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
}