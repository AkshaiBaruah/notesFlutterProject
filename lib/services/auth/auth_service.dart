import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/auth_user.dart';

class AuthService implements AuthProvider{
  final AuthProvider provider1;
  //....other provoders and in the end return the combined results
  AuthService(this.provider1);

  @override
  Future<AuthUser> createUser({required String email, required String password})
  => provider1.createUser(email: email, password: password);
  

  @override
  AuthUser? get currentUser => provider1.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password})
  =>provider1.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider1.logOut();

  @override
  Future<void> sendVerificationEmail() => provider1.sendVerificationEmail();

}