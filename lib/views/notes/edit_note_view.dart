import 'package:flutter/material.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/cloud/cloud_service.dart';
import 'package:my_notes/services/cloud/clout_note.dart';
import 'package:my_notes/utilities/generics/context_args.dart';

class EditNoteView extends StatefulWidget {
  const EditNoteView({Key? key}) : super(key: key);

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  CloudNote? _note;              //final source of truth for the builder func of this stful widget...because we don't want to recreate note on recall of build(hot reload);
  late final CloudService _noteService;
  late final TextEditingController _noteTextController;

  Future<CloudNote> editNote(BuildContext context) async {
    final existingNote = context.contextArgs<CloudNote>();

    if(existingNote != null){
      _note = existingNote;
      _noteTextController.text = existingNote.text;
      return existingNote;
    }
    final note = _note;
    if(note != null){
      return note;
    }
    //final userEmail = AuthService.fromFirebase().currentUser!.email;
    final userId = AuthService.fromFirebase().currentUser!.id;
    final newnote = await _noteService.createNote(userId: userId);
    _note = newnote;
    return newnote;
  }
  void _deleteNoteOnEmptyText()  {
    final note = _note;
    if(note != null && _noteTextController.text.isEmpty ){
       _noteService.deleteNote(docId: note.docId);
    }
  }
  void _saveNoteWithText() async {
    final note = _note;
    if(note != null && _noteTextController.text.isNotEmpty){
      await _noteService.updateNote(
          docId: note.docId ,
          newText: _noteTextController.text);
    }
  }
  void _noteTextListener() async {
    final note = _note;
    if(note == null) {
      return;
    }else{
      final newText = _noteTextController.text;
      await _noteService.updateNote(docId: note.docId, newText: newText);
    }

  }
  void setControllerListener(){
    _noteTextController.removeListener(_noteTextListener);
    _noteTextController.addListener(_noteTextListener);
  }
  @override
  void initState() {
    _noteService = CloudService();
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
              return const CircularProgressIndicator();
          }
        },
      )
    );
  }
}

