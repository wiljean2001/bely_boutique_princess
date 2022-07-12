import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../utils/show_alert.dart';
import '/repositories/repositories.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<auth.User?>? _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthState.unknown()) {
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthUserPasswordChanged>(_onAuthUserPasswordChanged);

    _userSubscription = _authRepository.user.listen((user) {
      add(AuthUserChanged(user: user));
    });
  }

  void _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    event.user != null
        ? emit(AuthState.authenticated(user: event.user!))
        : emit(const AuthState.unauthenticated());
  }

  void _onAuthUserPasswordChanged(
    AuthUserPasswordChanged event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository
        .changePassword(
      event.currentPassword,
      event.newPassword,
    )
        .then(
      (isValue) {
        if (isValue) {
          ShowAlert.showMessage(msg: 'Contraseña cambiada excitosamente.');
          return;
        }
        ShowAlert.showMessage(msg: 'Error.');
        return;
      },
    );
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
