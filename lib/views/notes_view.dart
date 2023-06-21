import 'package:flutter/material.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/utilities/show_error_dialog.dart';
import '../../services/auth/auth_exceptions.dart';
import 'dart:developer' as devtools show log;

import '../enums/menu_actions.dart';
class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          PopupMenuButton<MenuAction>(
              onSelected : (value ) async {
                if(value == MenuAction.logout){
                  final logoutval = await showLogoutDialog(context);
                  if(logoutval){
                    try{
                      await AuthService.fromFirebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
                    } on UserNotLoggedInAuthException
                    {
                       await showErrorDialog(context, 'User not logged in');
                    }


                  }
                }
                else if(value == MenuAction.settings) {
                  devtools.log(value.toString());
                }
              } ,
              itemBuilder: (context){
                return const [
                  PopupMenuItem<MenuAction>(
                      value : MenuAction.logout,
                      child: Text('Logout')
                  ),
                  PopupMenuItem<MenuAction>(
                      value : MenuAction.settings,
                      child: Text('Settings')
                  ),
                ];
              }
          ),
        ],
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context){
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Logout')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
          ],
        );
      },
  ).then((value) => value ?? false);
}
