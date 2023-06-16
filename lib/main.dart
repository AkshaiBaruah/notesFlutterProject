import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/views/auth/login_view.dart';
import 'package:my_notes/views/auth/register_view.dart';
import 'package:my_notes/views/auth/verify_email_view.dart';
import 'package:my_notes/views/notes_view.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;
void main() async {
  //create an instance of widgetbinding because firebase initializeapp need to run native code and widgetbining can use the native code
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter app',
      theme: ThemeData(
        primarySwatch: Colors.brown
        ,
      ),
      home:  const Homepage(),

      routes: {
        loginRoute : (context) => const LoginView(),
        registerRoute : (context) => const RegisterView(),
        verifyEmailRoute : (context) => const VerifyEmailView(),
        notesRoute : (context) => const NotesView(),
      },
    );
  }
}
class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    devtools.log(user.toString());
    if(user == null){
      return const RegisterView();
    }
    else{
      if(user.emailVerified){
        return const NotesView();
      }
      else{
        return const LoginView();
      }
    }
  }
}










