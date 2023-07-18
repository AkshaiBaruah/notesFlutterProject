
import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'dart:async';

import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/services/bloc/auth_events.dart';
class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email'),),
      body: Center(
        child: Column(
          children: [
            const Text('Please verify your email by clicking the button below'),
            TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(const AuthEventSendVerificationEmail());
                  Timer(const Duration(seconds: 3) , (){});
                },
                child: const Text('Send Verificatoin Email')),
            TextButton(onPressed: () {
              context.read<AuthBloc>().add(const AuthEventLogOut());
            }, child: const Text('Go back to Login'))
          ],
        ),
      ),
    );
  }
}

