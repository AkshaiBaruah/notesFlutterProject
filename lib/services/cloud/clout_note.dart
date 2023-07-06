
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudNote{
  final String docId;
  final String userId;
  final String text;

  CloudNote({
    required this.docId,
    required this.userId,
    required this.text,
 });
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, Object?>> snapshot)
    : docId = snapshot.id,
      userId = snapshot.data()['user_id'] as String,
      text = snapshot.data()['text'] as String;

}