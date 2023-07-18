import 'package:bloc/bloc.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/bloc/auth_events.dart';
import 'package:my_notes/services/bloc/auth_states.dart';

class AuthBloc extends Bloc<AuthEvent , AuthState>{
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()){
    //handling initialize event
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if(user == null){
        emit(const AuthStateLoggedOut());
      }else{
        if(user.isEmailVerified == false){
          emit(const AuthStateEmailNotVerified());
        }
        else{
          emit(AuthStateLoggedIn(user: user));
        }
      }
    });
    //handling login
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoading());
      final email = event.email;
      final password = event.password;
      try{
        final user = await provider.logIn(email: email, password: password);
        emit(AuthStateLoggedIn(user: user));
      } catch(e){
        emit(AuthStateLoginError(exception: e as Exception));
      }
    });
    //handling logout event
    on<AuthEventLogOut>((event, emit) async {
      emit(const AuthStateLoading());
      try{
        await provider.logOut();
        emit(const AuthStateLoggedOut());
      } catch(e){
        emit(AuthStateLogOutError());
      }
    });

  }

}