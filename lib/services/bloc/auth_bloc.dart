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
        emit(const AuthStateLoggedOut(null));
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
      final email = event.email;
      final password = event.password;
      try{
        final user = await provider.logIn(email: email, password: password);          //this provider.login will only throw Exceptions
        emit(AuthStateLoggedIn(user: user));
      } catch(e){
        emit(AuthStateLoggedOut(e as Exception));               //therefore e is guaranteed  to be an exception
      }
    });
    //handling logout event
    on<AuthEventLogOut>((event, emit) async {
      emit(const AuthStateLoading());
      try{
        await provider.logOut();
        emit(const AuthStateLoggedOut(null));
      } catch(e){
        emit(const AuthStateLogOutError());
      }
    });

  }

}