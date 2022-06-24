part of 'role_bloc.dart';

abstract class RoleState extends Equatable {
  const RoleState();

  @override
  List<Object> get props => [];
}

class RoleLoading extends RoleState {}

class RoleLoaded extends RoleState {
  final List<User> users;
  final String? role;

  const RoleLoaded({
    required this.users,
    required this.role
  });

  @override
  List<Object> get props => [users];
}

class RoleError extends RoleState {}
