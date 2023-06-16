import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'dart:async';
class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email'),),
      body: Column(
        children: [
          const Text('Please verify your email by clicking the button below'),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                Timer(Duration(seconds: 3) , (){});
              },
              child: const Text('Send Verificatoin Email')),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil (loginRoute, (route) => false);
          }, child: const Text('Go back to Login'))
        ],
      ),
    );
  }
}

