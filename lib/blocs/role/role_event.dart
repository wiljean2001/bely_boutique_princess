part of 'role_bloc.dart';

abstract class RoleEvent extends Equatable {
  const RoleEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends RoleEvent {
  final String role;

  const LoadUsers({
    required this.role,
  });
  // required this.userId,

  @override
  List<Object?> get props => [role]; //userId
}

class UpdateHome extends RoleEvent {
  final List<User>? users;
  final String? role;

  const UpdateHome({
    required this.users,
    required this.role
  });

  @override
  List<Object?> get props => [users];
}

class UpdateRoleUser extends RoleEvent {
  final User user;

  const UpdateRoleUser({required this.user});

  @override
  List<Object?> get props => [user];
}