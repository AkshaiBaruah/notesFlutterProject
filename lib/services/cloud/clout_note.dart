import 'package:cloud_firestore/cloud_firestore.dart';

class CloudNote{
  final String docId;
  final String userId;
  final String text;

  const CloudNote({
    required this.docId,
    required this.userId,
    required this.text,
 });
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
    : docId = snapshot.id,
      userId = snapshot.data()['user_id'],
      text = snapshot.data()['text'] as String;

}