import 'package:flutter/foundation.dart';
import 'package:my_notes/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState{
  const AuthStateUninitialized();
}
class AuthStateLoggedIn extends AuthState{
  final AuthUser user;
  const AuthStateLoggedIn({required this.user});
}
class AuthStateEmailNotVerified extends AuthState{
  const AuthStateEmailNotVerified();
}
class AuthStateLoggedOut extends AuthState{
  final Exception? exception;
  final bool isLoading ;
  const AuthStateLoggedOut(this.exception , this.isLoading);
}
class AuthStateLogOutError extends AuthState{
  const AuthStateLogOutError();
}
class AuthStateRegisterScreen extends AuthState{
  final Exception? exception;
  final bool isLoading;
  const AuthStateRegisterScreen(this.exception , this.isLoading);
}

