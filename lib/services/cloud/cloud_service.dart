import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes/services/cloud/cloud_exceptions.dart';
import 'package:my_notes/services/cloud/clout_note.dart';

class CloudService{
  //singleton
  static final _shared = CloudService._sharedInstance();
  CloudService._sharedInstance();
  factory CloudService() => _shared;
  
  final _notes = FirebaseFirestore.instance.collection('notes');

  Future<CloudNote> createNote({required String userId}) async{
    try{
      final doc = await _notes.add({
        'user_id' : userId,
        'text' : '',
      });
      final fetchedNote = await doc.get();
      return CloudNote(
          docId: fetchedNote.id,
          userId: userId,
          text: ''
      );
    } catch (e){
      throw CouldNotCreateNoteException();
    }
  }

  Future<Iterable<CloudNote>> getAllNotes({required userId}) async{
    try {
      return await _notes.where(
          'user_id',
          isEqualTo: userId
      ).get()
      .then((value) => value.docs.map((doc) {
        return CloudNote.fromSnapshot(doc);
      }
      )
      );
    } catch (e) {
      throw CouldNotGetNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required userId}){
    return _notes.snapshots().map((event) => event.docs
        .map((doc) {
      return CloudNote.fromSnapshot(doc);
    }).where((note) => note.userId == userId));
  }

  Future<void> updateNote({
    required String docId,
    required String newText,
}) async {
    try{
      await _notes.doc(docId).update({'text' : newText});
    } catch (_){
      throw CouldNotUpdateNoteException();
    }

  }
  Future<void> deleteNote({
    required String docId,
  }) async {
    try{
      await _notes.doc(docId).delete();
    } catch(_){
      throw CouldNotDeleteNoteException();
    }

  }

  Future<void> deleteAllNotes({required String userId}) async {
    final allnotes = await getAllNotes(userId: userId);
    for(final cloudNote in allnotes){
      await deleteNote(docId: cloudNote.docId);
    }
  }
}