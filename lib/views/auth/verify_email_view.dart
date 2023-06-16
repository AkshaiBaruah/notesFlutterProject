import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify Email'),),
      body: Column(
        children: [
          Text('Please verify your email by clicking the button below'),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: Text('Send Verificatoin Email')),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil ('/login/', (route) => false);
          }, child: Text('Go back to Login'))
        ],
      ),
    );
  }
}

