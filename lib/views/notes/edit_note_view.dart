import 'package:flutter/material.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/crud/notes_service.dart';
import 'package:my_notes/utilities/generics/context_args.dart';

class EditNoteView extends StatefulWidget {
  const EditNoteView({Key? key}) : super(key: key);

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  DatabaseNote? _note;              //final source of truth for the builder func of this stful widget...because we don't want to recreate note on recall of build(hot reload);
  late final NoteService _noteService;
  late final TextEditingController _noteTextController;

  Future<DatabaseNote> editNote(BuildContext context) async {
    final existingNote = context.contextArgs<DatabaseNote>();
    if(existingNote != null){
      _note = existingNote;
      _noteTextController.text = existingNote.text;
    }
    if(_note != null){
      return _note!;
    }
    final userEmail = AuthService.fromFirebase().currentUser!.email!;
    final user = await _noteService.getUser(email: userEmail);
    _note = await _noteService.insertNote(user: user);
    return _note!;
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
      await _noteService.updateNote(note: note, newText: _noteTextController.text);
    }
  }
  void _noteTextListenner() async {
    final note = _note;
    if(note == null)  return;
    final newText = _noteTextController.text;
    _note = await _noteService.updateNote(note: note, newText: newText);
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
        title: const Text('Edit Note'),

      ),
      body: FutureBuilder(
        future: editNote(context),
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

