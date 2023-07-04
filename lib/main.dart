import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/views/auth/login_view.dart';
import 'package:my_notes/views/auth/register_view.dart';
import 'package:my_notes/views/auth/verify_email_view.dart';
import 'package:my_notes/views/notes/edit_note_view.dart';
import 'package:my_notes/views/notes/notes_view.dart';
import 'dart:developer' as devtools show log;

void main() async {
  //create an instance of widgetbinding because firebase initializeapp need to run native code and widgetbining can use the native code
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.fromFirebase().initialize();
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
        editNoteRoute : (context) => const EditNoteView(),
      },
    );
  }
}
class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = AuthService.fromFirebase().currentUser;
    devtools.log(user.toString());
    if(user == null){
      return const RegisterView();
    }
    else{
      if(user.isEmailVerified){
        return const NotesView();
      }
      else{
        return const LoginView();
      }
    }
  }
}










