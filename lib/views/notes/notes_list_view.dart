import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/crud/notes_service.dart';
import 'package:my_notes/utilities/Dialogs/delete_dialog.dart';

class NoteListView extends StatelessWidget {

  final List<DatabaseNote> notes;
  final void Function(DatabaseNote note) onDelete;          //this is the function signature that we are gonna provide to this class in order
  final void Function(DatabaseNote note) onTap;             //for this class to call it from here(note is not passed here. When this class
                                                            //user this callback, it has to give the input note of type DatabaseNote
  const NoteListView({
    Key? key,
    required this.notes,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0 , bottom: 20),
      child: ListView.builder(
        itemCount : notes.length,
        itemBuilder: (context , index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16.0),
            child: ListTile(
              onTap: () {
                onTap(notes[index]);
              },
              title:  Text(
                notes[index].text,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              shape:  RoundedRectangleBorder(
                side: BorderSide(color: Colors.black , width: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              trailing: IconButton(
                  onPressed: () async {
                    final shouldDel = await showDeleteDialog(context);
                    if(shouldDel){
                      onDelete(notes[index]);
                    }
                  },
                  icon: Icon(Icons.delete)),

            ),

          );
        },
      ),
    );
  }
}
