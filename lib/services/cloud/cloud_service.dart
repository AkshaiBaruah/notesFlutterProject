import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes/services/cloud/cloud_exceptions.dart';
import 'package:my_notes/services/cloud/clout_note.dart';

class CloudService{
  //singleton
  static final _shared = CloudService._sharedInstance();
  CloudService._sharedInstance();
  factory CloudService() => _shared;
  
  final _notes = FirebaseFirestore.instance.collection('notes');

  void createNote({required String userId}) async{
    try{
      await _notes.add({
        'user_ud' : userId,
        'text' : '',
      });
    } catch (e){
      throw CouldNotCreateNoteException();
    }
  }

  Future<List<CloudNote>> getAllNotes({required userId}) async{
    try {
      return await _notes.where(
          'user_id ',
          isEqualTo: userId
      ).get()
      .then((value) => value.docs.map((doc) {
        return CloudNote(
            docId: doc.id,
            userId: doc.data()['user_id'],
            text: doc.id
        );
      }
      ).toList()
      );
    } catch (e) {
      throw CouldNotGetNotesException();
    }
  }

  Stream<List<CloudNote>> allNotes({required userId}){
    return _notes.snapshots().map((event) => event.docs.map((doc) {
      return CloudNote(docId: doc.id, userId: doc.data()['user_id'], text: doc.data()['text']);
    }).toList());
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
    required docId,
}) async {
    try{
      await _notes.doc(docId).delete();
    } catch(_){
      throw CouldNotDeleteNoteException();
    }

  }
}