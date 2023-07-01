import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/crud/notes_service.dart';
import 'package:my_notes/utilities/show_error_dialog.dart';
import '../../../services/auth/auth_exceptions.dart';
import 'dart:developer' as devtools show log;

import '../../enums/menu_actions.dart';
class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NoteService _noteService;
  String get userEmail => AuthService.fromFirebase().currentUser!.email!;

  @override
  void initState() {
    _noteService = NoteService();
    super.initState();
  }

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
      body: FutureBuilder(
        future: _noteService.getOrCreateUser(email: userEmail),
        builder: (context , snapshot){
            switch(snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                    stream : _noteService.allNotes,
                    builder: (context , snapshot){
                      switch(snapshot.connectionState){

                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if(snapshot.hasData){
                            final allNotes = snapshot.data;
                            return Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: ListView.builder(
                                  itemCount : allNotes!.length,
                                  itemBuilder: (context , index){
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16.0),
                                      child: ListTile(
                                        title:  Text(
                                            allNotes[index].text,
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                        ),
                                        shape:  RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.black , width: 0.3),
                                          borderRadius: BorderRadius.circular(10),
                                        ),

                                      ),

                                    );
                                  },
                              ),
                            );
                          }else{
                            return const CircularProgressIndicator();
                          }
                        default :
                          return const CircularProgressIndicator();
                      }
                    }
                );
              default :
                return CircularProgressIndicator();
            }
          },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(addNewNoteRoute);
        },
        child: const Icon(Icons.add, color: Colors.tealAccent,),
        enableFeedback: true,


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
