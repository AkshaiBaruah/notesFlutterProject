
import 'package:flutter/foundation.dart';

@immutable
class AuthEvent{
  const AuthEvent();
}
class AuthEventInitialize extends AuthEvent{
  const AuthEventInitialize();
}
class AuthEventLogIn extends AuthEvent{
  final String email;
  final String password;
  const AuthEventLogIn({required this.email, required this.password});
}
class AuthEventRegister extends AuthEvent{
  final String email;
  final String password;
  const AuthEventRegister({required this.email, required this.password});
}
class AuthEventLogOut extends AuthEvent{
  const AuthEventLogOut();
}
class AuthEventSendVerificationEmail extends AuthEvent{
  const AuthEventSendVerificationEmail();
}
class AuthEventNavigateToRegister extends AuthEvent{
  const AuthEventNavigateToRegister();
}