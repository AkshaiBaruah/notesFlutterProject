import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/bloc/auth_events.dart';
import 'package:my_notes/services/bloc/auth_states.dart';

class AuthBloc extends Bloc<AuthEvent , AuthState>{
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()){
    //handling initialize event
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if(user == null){
        emit(const AuthStateLoggedOut(null,false));
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
      emit(const AuthStateLoggedOut(null, true));
      final email = event.email;
      final password = event.password;
      try{
        final user = await provider.logIn(email: email, password: password);          //this provider.login will only throw Exceptions
        emit(AuthStateLoggedIn(user: user));
      } catch(e){
        emit(AuthStateLoggedOut(e as Exception, false));               //therefore e is guaranteed  to be an exception
      }
    });
    //handling logout event
    on<AuthEventLogOut>((event, emit) async {
      try{
        await provider.logOut();
        emit(const AuthStateLoggedOut(null , false));
      } catch(e){
        emit(AuthStateLoggedOut(e as Exception , false));
      }
    });
    //handling register
    on<AuthEventRegister>((event , emit)async {
      emit(const AuthStateRegisterScreen(null, true));
      final String email = event.email;
      final password = event.password;

      try{
        await provider.createUser(email: email, password: password);
        emit(const AuthStateEmailNotVerified());
      } catch (e){
        emit(AuthStateRegisterScreen(e as Exception , false));
      }
    });

    //handling send email verification event
    on<AuthEventSendVerificationEmail>((event , emit) async {
      try{
        await provider.sendVerificationEmail();
      } catch (e){
        emit(AuthStateRegisterScreen(e as Exception , false));           //user was not registered(UserNotLoggedIn)
      }

    });
    on<AuthEventNavigateToRegister>((event , emit) {
      emit(const AuthStateRegisterScreen(null , false));
    });
  }

}