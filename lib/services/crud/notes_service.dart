import 'dart:async';
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
  DatabaseUser? user;

  //singleton for making a single instance (sharedinstance of NotesService)
  static final _shared = NoteService._sharedInstance();     //the shared instance of notes
  NoteService._sharedInstance(){                             //constructor
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: (){
        _notesStreamController.sink.add(_notes);
      },
    );
  }
  factory NoteService() => _shared;                         //factory constructor that returns the shared single instance of NoteService

  List<DatabaseNote> _notes = [];            //final source of truth of the notes that the service talks to
  late final StreamController<List<DatabaseNote>> _notesStreamController ;

  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;


  //methods

  Future<void> _cacheNotes() async {
    List<DatabaseNote> allNotes = await getAllNotes();
    _notes = allNotes;
    _notesStreamController.add(_notes);
  }

  Database get instance {
    final db = _db;
    if(db != null){
      return db;
    }else{
      throw DatabaseNotOpenException();
    }
  }
  // we will ensure db is open in all functions
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

  Future<void> ensureDbOpen() async {
    try{
      await open();
    } on DatabaseAlreadyOpenException{
      //do nothing
    }
  }

  Future<DatabaseUser> getOrCreateUser({required String email , bool setCurrUser = true}) async {
    await ensureDbOpen();
    try{
      final dbUser = await getUser(email: email);
      if(setCurrUser){
        user = dbUser;
      }
      await _cacheNotes();
      return dbUser;
    } on UserDoesNotExistException {
      final dbUser = await createUser(email: email);
      if(setCurrUser){
        user = dbUser;
      }
      await _cacheNotes();
      return dbUser;
    } catch(e){
      rethrow;
    }
  }

  Future<void> deleteUser({required String email}) async {
    await ensureDbOpen();
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
    await ensureDbOpen();
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
    await ensureDbOpen();
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
    await ensureDbOpen();
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
    final note = DatabaseNote(id: dbNoteId, userId: user.id, text: '');
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<void> deleteNote({required int noteId}) async {
    await ensureDbOpen();
    final db = instance;

    final delcnt = await db.delete(
        noteTable,
        where : 'id = ?',
        whereArgs : [noteId],
    );
    if(delcnt != 1){
      throw CouldNotDeleteNoteException();
    }else{
      _notes.removeWhere((note) => note.id == noteId);
      _notesStreamController.add(_notes);
    }
  }

  Future<int> deleteAllNotes()async{
    await ensureDbOpen();
    final db = instance;
    final delcnt = await db.delete(noteTable);
    _notes.clear();
    _notesStreamController.add(_notes);
    return delcnt;
  }
  //gets the node with given id and also updates in the cache
  Future<DatabaseNote> getNote({required int noteId})async {
    await ensureDbOpen();
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
      final note =  DatabaseNote.fromRow(result.first);
      _notes.removeWhere((note) => note.id == noteId);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<List<DatabaseNote>> getAllNotes() async {
    if(user == null) throw NoUserFoundException;
    await ensureDbOpen();
    final db = instance;
    final dbUser = await db.query(userTable ,
        limit: 1 ,
        where: 'email = ?' ,
        whereArgs: [user!.email]
    );
    final user_id = dbUser.first['id'] as int;
    final result = await db.query(
        noteTable ,
        where: 'user_id = ?',
        whereArgs: [user_id],
    );
    List<DatabaseNote> notes = [];
    for(int i = 0 ; i<result.length ; i++){
      notes.add(DatabaseNote.fromRow(result[i]));
    }
    return notes;
  }

  Future<DatabaseNote> updateNote({required DatabaseNote note ,  String newText = ''})async {
    await ensureDbOpen();
    final db = instance;
    //will work else CouldNotFindNoteException
    await getNote(noteId: note.id); //this will throw an excecption if note with the given id is not present

    //uodate DB
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
      //cnt != 0 means db updated..now get note will get the note from DB and also update it in the local cache;
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
        CREATE TABLE IF NOT EXISTS "user" (
	      "id"	INTEGER NOT NULL,
	      "email"	TEXT NOT NULL,
	      PRIMARY KEY("id" AUTOINCREMENT)
      );''';
const createNoteTable = '''
      CREATE TABLE IF NOT EXISTS "note" (
	    "id"	INTEGER NOT NULL,
	    "user_id"	INTEGER NOT NULL,
	    "text"	TEXT,
	    PRIMARY KEY("id" AUTOINCREMENT),
	    FOREIGN KEY("user_id") REFERENCES "user"("id")
      );''';


