class CloudExceptions implements Exception {
  CloudExceptions();
}

class CouldNotCreateNoteException implements CloudExceptions {}

class CouldNotGetNotesException implements CloudExceptions {}

class CouldNotUpdateNoteException implements CloudExceptions {}

class CouldNotDeleteNoteException implements CloudExceptions {}