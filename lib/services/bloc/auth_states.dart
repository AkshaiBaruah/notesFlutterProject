import 'package:flutter/foundation.dart';
import 'package:my_notes/services/auth/auth_user.dart';

@immutable
class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState{
  const AuthStateLoading();
}
class AuthStateLoggedIn extends AuthState{
  final AuthUser user;
  const AuthStateLoggedIn({required this.user});
}
class AuthStateLoginError extends AuthState{
  final Exception exception;
  const AuthStateLoginError({required this.exception});
}
class AuthStateEmailNotVerified extends AuthState{
  const AuthStateEmailNotVerified();
}
class AuthStateLoggedOut extends AuthState{
  const AuthStateLoggedOut();
}
class AuthStateLogOutError extends AuthState{
  const AuthStateLogOutError();
}

