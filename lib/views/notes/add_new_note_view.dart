import 'package:flutter/material.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/crud/notes_service.dart';

class AddNewNoteView extends StatefulWidget {
  const AddNewNoteView({Key? key}) : super(key: key);

  @override
  State<AddNewNoteView> createState() => _AddNewNoteViewState();
}

class _AddNewNoteViewState extends State<AddNewNoteView> {
  DatabaseNote? _note;              //final source of truth for the builder func of this stful widget...because we don't want to recreate note on recall of build(hot reload);
  late final NoteService _noteService;
  late final TextEditingController _noteTextController;

  Future<DatabaseNote> addNewNote() async {
    if(_note != null){
      return _note!;
    }
    final userEmail = AuthService.fromFirebase().currentUser!.email!;
    final user = await _noteService.getUser(email: userEmail);
    return await _noteService.insertNote(user: user);
  }
  void _deleteNoteOnEmptyText() async {
    final note = _note;
    if(note != null && _noteTextController.text.isEmpty ){
      await _noteService.deleteNote(noteId: note.id);
    }
  }
  void _saveNoteWithText() async {
    final note = _note;
    if(note != null && _noteTextController.text.isNotEmpty){
      await _noteService.updataNote(note: note, newText: _noteTextController.text);
    }
  }
  void _noteTextListenner() async {
    final note = _note;
    if(note == null)  return;
    final newText = _noteTextController.text;
    _note = await _noteService.updataNote(note: note, newText: newText);
  }
  void setControllerListener(){
    _noteTextController.removeListener(_noteTextListenner);
    _noteTextController.addListener(_noteTextListenner);
  }
  @override
  void initState() {
    _noteService = NoteService();
    _noteTextController = TextEditingController();
    setControllerListener();
    super.initState();
  }
  @override
  void dispose() {
    _deleteNoteOnEmptyText();
    _saveNoteWithText();
    _noteTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your note'),

      ),
      body: FutureBuilder(
        future: addNewNote(),
        builder: (context , snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.done:
              _note = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  expands: true,
                  controller: _noteTextController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Type your note here',
                  ),
                ),
              );

            default :
              return CircularProgressIndicator();
          }
        },
      )
    );
  }
}

