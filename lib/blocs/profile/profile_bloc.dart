import 'dart:async';

import 'package:bely_boutique_princess/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '/blocs/auth/auth_bloc.dart';
import '/models/models.dart';
import '/repositories/database/database_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

// Todo corresponidente al usuario
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;
  StreamSubscription? _authSubscription;

  ProfileBloc({
    required AuthBloc authBloc,
    required StorageRepository storageRepository,
    required DatabaseRepository databaseRepository,
  })  : _authBloc = authBloc,
        _storageRepository = storageRepository,
        _databaseRepository = databaseRepository,
        super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateUserProfile>(_onUpdateUser);

    _authSubscription = _authBloc.stream.listen((state) {
      if (state.user is AuthUserChanged) {
        if (state.user != null) {
          add(LoadProfile(userId: state.user!.uid));
        }
      }
    });
  }

  void _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) {
    _databaseRepository.getUser(event.userId).listen((user) {
      add(
        UpdateProfile(user: user),
      );
    });
  }

  void _onUpdateUser(
    UpdateUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    await _databaseRepository.updateUser(event.user).then(
      (value) async {
        if (event.image != null) {
          await _storageRepository.uploadImage(event.user, event.image!);
        }
        add(
          LoadProfile(userId: event.user.id!),
        );
      },
    );
  }

  void _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileLoaded(user: event.user));
  }

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    super.close();
  }
}
