import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'role_event.dart';
part 'role_state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _roleSubscription;
  RoleBloc({
    // required AuthBloc authBloc,
    required DatabaseRepository databaseRepository,
  })  : _databaseRepository = databaseRepository,
        super(RoleLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<UpdateHome>(_onUpdateHome);
    on<UpdateRoleUser>(_onUpdateUser);
  }

  void _onLoadUsers(
    LoadUsers event,
    Emitter<RoleState> emit,
  ) {
    _roleSubscription = _databaseRepository.getUsers(event.role).listen(
      (users) {
        //event.userId,
        print('$users');
        add(
          UpdateHome(users: users, role: event.role),
        );
      },
    );
  }

  void _onUpdateHome(
    UpdateHome event,
    Emitter<RoleState> emit,
  ) {
    if (event.users != null) {
      emit(RoleLoaded(users: event.users!, role: event.role));
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
    _roleSubscription?.cancel();
    super.close();
  }
}
