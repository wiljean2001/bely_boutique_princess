import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/repositories/auth/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

part 'signup_state.dart';

/// Solucion para manejo de estados sencillo
/// Clase SignupCubit -> nuestro cubit
class SignupCubit extends Cubit<SignupState> {
  // preparamos la inyeccion del repositorio -> AuthRepository
  final AuthRepository _authRepository;

  //Constructor recibe obligatoriamente un objeto de la clase AuthRepository
  SignupCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        // Inyeccion de dependencias
        super(SignupState.initial());

  /// funcion emailChangend
  /// emitirá un nuevo estado de email,
  void emailChanged(String value) {
    // emite nuevo estado continuamente inicial mientras escriba el gmail
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  Future<void> signUpWithCredentials() async {
    //validacion de campos
    if (!state.isFormValid || state.status == SignupStatus.submitting) return;

    // Caso contrario
    emit(state.copyWith(
        status: SignupStatus.submitting)); // emite nuevo estado submitting
    // Intenta crear nuevo usuario
    try {
      var user = await _authRepository.signUp(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(
          status: SignupStatus.success,
          user: user)); // emite nuevo estado user success
    } catch (_) {}
  }

  Future<void> signInWithCredentials() async {
    //validacion de campos
    if (!state.isFormValid || state.status == SignupStatus.submitting) return;

    // Caso contrario
    emit(state.copyWith(
        status: SignupStatus.submitting)); // emite nuevo estado submitting
    // Intenta crear nuevo usuario
    try {
      var user = await _authRepository.signIn(
        email: state.email,
        password: state.password,
      );
      if (user != null) {
        emit(
          state.copyWith(status: SignupStatus.success, user: user),
        );
      } // emite nuevo estado user success
    } catch (_) {}
  }
}
