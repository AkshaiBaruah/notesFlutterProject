import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/crud/notes_service.dart';
import 'package:my_notes/views/notes/notes_list_view.dart';
import '../../../services/auth/auth_exceptions.dart';
import 'dart:developer' as devtools show log;

import '../../enums/menu_actions.dart';
import '../../utilities/Dialogs/error_dialog.dart';
import '../../utilities/Dialogs/logout_dialog.dart';
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
                            return NoteListView(
                                notes: allNotes!,
                                onDelete: (note) async{
                                  await _noteService.deleteNote(noteId: note.id);
                                },
                                onTap: (note) async{
                                  Navigator.of(context).pushNamed(editNoteRoute , arguments: note);
                                },
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
          Navigator.of(context).pushNamed(editNoteRoute);
        },
        child: const Icon(Icons.add, color: Colors.tealAccent,),
        enableFeedback: true,


      ),
    );
  }
}
