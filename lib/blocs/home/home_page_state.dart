part of 'home_page_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {}

// Estado de bottomNavitagion
class BottomNavigationInitial extends HomePageState {
  final int indexBottomNav;

  const BottomNavigationInitial({this.indexBottomNav = 0});

  @override
  List<Object> get props => [indexBottomNav];
}

// class RoleUserLoading extends HomePageState {}

// class RoleUserLoaded extends HomePageState {
//   final User user;

//   const RoleUserLoaded({required this.user});

//   @override
//   List<Object> get props => [user];
// }
