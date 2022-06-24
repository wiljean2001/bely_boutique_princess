import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'role_event.dart';
part 'role_state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  final AuthBloc _authBloc;
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _authSubscription;

  RoleBloc({
    required AuthBloc authBloc,
    required DatabaseRepository databaseRepository,
  })  : _authBloc = authBloc,
        _databaseRepository = databaseRepository,
        super(RoleLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<UpdateHome>(_onUpdateHome);
    on<UpdateRoleUser>(_onUpdateUser);

    _authSubscription = _authBloc.stream.listen((state) {
      if (state.status == AuthStatus.authenticated) {
        add(const LoadUsers(role: 'admin')); //userId: state.user!.uids
      }
    });
  }

  void _onLoadUsers(
    LoadUsers event,
    Emitter<RoleState> emit,
  ) {
    _databaseRepository.getUsers(event.role).listen((users) {
      //event.userId,
      print('$users');
      add(
        UpdateHome(users: users),
      );
    });
  }

  void _onUpdateHome(
    UpdateHome event,
    Emitter<RoleState> emit,
  ) {
    if (event.users != null) {
      emit(RoleLoaded(users: event.users!));
    } else {
      emit(RoleError());
    }
  }

  void _onUpdateUser(
    UpdateRoleUser event,
    Emitter<RoleState> emit,
  ) {
    _databaseRepository.updateUser(event.user).then(
          (value) => add(
            const LoadUsers(role: 'admin'),
          ),
        );
  }

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    super.close();
  }
}
