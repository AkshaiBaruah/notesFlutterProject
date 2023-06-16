import 'package:flutter/material.dart';
import 'package:my_notes/views/auth/login_view.dart';
import 'package:my_notes/views/auth/register_view.dart';
import 'package:my_notes/views/auth/verify_email_view.dart';
import 'package:my_notes/views/notes_view.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  //create an instance of widgetbinding because firebase initializeapp need to run native code and widgetbining can use the native code
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
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
      home:  Homepage(),

      routes: {
        '/login/' : (context) => const LoginView(),
        '/register/' : (context) => const RegisterView(),
        '/verifyemail/' : (context) => const VerifyEmailView(),
        '/notes/' : (context) => const NotesView(),
      },
    );
  }
}
class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    print(user);
    if(user == null){
      return RegisterView();
    }
    else{
      if(user.emailVerified){
        return NotesView();
      }
      else{
        return LoginView();
      }
    }
  }
}










