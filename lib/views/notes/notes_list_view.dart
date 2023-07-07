import 'package:flutter/material.dart';
import 'package:my_notes/services/cloud/clout_note.dart';
import 'package:my_notes/utilities/Dialogs/delete_dialog.dart';

class NoteListView extends StatelessWidget {

  final Iterable<CloudNote> notes;
  final void Function(CloudNote note) onDelete;          //this is the function signature that we are gonna provide to this class in order
  final void Function(CloudNote note) onTap;             //for this class to call it from here(note is not passed here. When this class
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
            child: Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.white60,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ListTile(
                leading: const Padding(
                  padding:  EdgeInsets.only(top: 9),
                  child: Icon(Icons.edit_note_sharp),
                ),
                onTap: () {
                  onTap(notes.elementAt(index));
                },
                title:  Text(
                  notes.elementAt(index).text,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text("this is a subtitle"),
                trailing: IconButton(
                    onPressed: () async {
                      final shouldDel = await showDeleteDialog(context);
                      if(shouldDel){
                        onDelete(notes.elementAt(index));
                      }
                    },
                    icon: Icon(Icons.delete)),

              ),
            ),

          );
        },
      ),
    );
  }
}
