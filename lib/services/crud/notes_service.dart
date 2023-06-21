import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'crud_exceptions.dart';


class DatabaseUser{
  final int id;
  final String email;

  DatabaseUser({required this.id , required this.email});

  DatabaseUser.fromRow(Map<String , Object?> map)
      : id = map[idCol] as int , email = map[emailCol] as String;            //initializer list

  @override
  String toString() => 'id = $id , email = $email';

  @override
  bool operator == (covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;


}

class DatabaseNote{
  final int id;
  final String text;
  final int userId;

  DatabaseNote({required this.id , required this.userId , required this.text});

  DatabaseNote.fromRow(Map<String , Object?> map)
    : id = map[idCol] as int,
      userId = map[userIdCol] as int,
      text = map[textCol] as String;

  @override
  String toString() => 'ID : $id , userId = $userId';

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator == (covariant DatabaseNote other) => id == other.id;
}

class NoteService{
  Database? _db;

  Database get instance {
    final db = _db;
    if(db != null){
      return db;
    }else{
      throw DatabaseNotOpenException();
    }
  }
  Future<void> open() async {
    if(_db != null){
      throw DatabaseAlreadyOpenException();
    }
    try{
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path , dbName);
      _db = await openDatabase(dbPath);

      await _db?.execute(createUserTable);
      await _db?.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw DocsDirectoryNotFoundException();
    }
  }

  Future<void> close() async{
    if(_db == null){
      throw DatabaseNotOpenException();
    }else{
      await _db?.close();
      _db = null;
    }
  }

  Future<void> deleteUser({required String email}) async {
    final db = instance;
    final delcnt = await db.delete(
        userTable ,
        where: 'email = ?',
        whereArgs: [email.toLowerCase()],
    );
    if(delcnt != 1){
      throw CouldNotDeleteUserException();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = instance;
    final result = await db.query(
        userTable ,
        limit: 1,
        where : 'email = ?',
        whereArgs: [email.toLowerCase()]
    );
    if(result.isNotEmpty){
      throw UserAlreadyExistsException();
    }
    final userId = await db.insert(
        userTable,
        {emailCol : email.toLowerCase()},
    );
    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = instance;
    final result = await db.query(
        userTable ,
        limit: 1,
        where : 'email = ?',
        whereArgs: [email.toLowerCase()]
    );
    if(result.isEmpty){
      throw UserDoesNotExistException();
    }else{
      return DatabaseUser.fromRow(result.first);
    }


  }

  Future<DatabaseNote> insertNote({required DatabaseUser user}) async {
    final db = instance;
    final dbUser = await getUser(email: user.email);
    if(user != dbUser){
      throw UserDoesNotExistException();
    }
    final dbNoteId = await db.insert(
        noteTable, {
        userIdCol: user.id,
        textCol: '',
      });

    return DatabaseNote(id: dbNoteId, userId: user.id, text: '');
  }
  Future<void> deleteNote({required int nodeId}) async {
    final db = instance;

    final delcnt = await db.delete(
        noteTable,
        where : 'id = ?',
        whereArgs : [nodeId],
    );
    if(delcnt != 1){
      throw CouldNotDeleteNoteException();
    }
  }
  Future<int> deleteAllNotes({required DatabaseUser user})async{
    final db = instance;
    final dbUser = getUser(email: user.email);
    if(dbUser != user){
      throw UserDoesNotExistException();
    }else{
      final delcnt = await db.delete(noteTable);
      return delcnt;
    }
  }
  Future<DatabaseNote> getNote({required int noteId})async {
    final db = instance;
    final result = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [noteId],
    );
    if(result.isEmpty) {
      throw CouldNotFindNoteException();
    }else{
      return DatabaseNote.fromRow(result.first);
    }
  }
  Future<List<DatabaseNote>> getAllNotes({required DatabaseUser user}) async {
    final db = instance;
    final dbUser = await getUser(email: user.email);
    if(user != dbUser){
      throw UserDoesNotExistException();
    }else{
      final result = await db.query(
        noteTable,
        where: 'user_id = ?',
        whereArgs: [user.id],
      );
      final notes = <DatabaseNote>[];
      for(int i = 0 ; i<result.length ; i++){
        notes.add(DatabaseNote.fromRow(result[i]));
      }
      return notes;
    }
  }

  Future<DatabaseNote> updataNote({required DatabaseNote note , required String newText})async {
    final db = instance;
    //will work else CouldNotFindNoteException
    await getNote(noteId: note.id); //this will throw an excecption if note with the given id is not present
    final updatecnt = await db.update(
        noteTable, {
          textCol : newText
        },
        where: 'id = ?',
        whereArgs: [note.id]
    );
    if(updatecnt == 0){
      throw CouldNotUpdateNoteException();
    }else{
      return getNote(noteId: note.id);  //return the updated note so that we can update it in our logic
    }

  }
}


const String idCol = 'id';
const String emailCol = 'email';
const String userIdCol = 'user_id';
const String textCol = 'text';
const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const createUserTable = '''
        CREATE TABLE IF NOT EXIST "user" (
	      "id"	INTEGER NOT NULL,
	      "email"	TEXT NOT NULL,
	      PRIMARY KEY("id" AUTOINCREMENT)
      );''';
const createNoteTable = '''
      CREATE TABLE IF NOT EXIST "note" (
	    "id"	INTEGER NOT NULL,
	    "user_id"	INTEGER NOT NULL,
	    "text"	TEXT,
	    PRIMARY KEY("id" AUTOINCREMENT),
	    FOREIGN KEY("user_id") REFERENCES "user"("id")
      );''';


