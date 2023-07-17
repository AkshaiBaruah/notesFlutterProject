import 'package:bloc/bloc.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/bloc/auth_events.dart';
import 'package:my_notes/services/bloc/auth_states.dart';

class AuthBloc extends Bloc<AuthEvent , AuthState>{
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()){
    on<AuthEventInitialize>((event, emit) {

    });

    on<AuthEventLogIn>((event, emit) {

    });

    on<AuthEventLogOut>((event, emit) {

    });

    on<AuthEventInitialize>((event, emit) {

    });
  }

}