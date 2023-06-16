//login exceptions
class UserNotFoundAuthException implements Exception{}
class WrongPasswordAuthException implements Exception{}

//register exception
class InvalidEmailAuthException implements Exception{}
class WeakPasswordAuthException implements Exception{}
class EmailAlreadyInUseAuthException implements Exception{}

//generic exceptions
class GenericAuthException implements Exception {}
class UserNotLoggedInAuthException implements Exception{}

