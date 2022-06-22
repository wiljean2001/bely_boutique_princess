
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_page_event.dart';

part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  // final AuthBloc _authBloc;
  // final DatabaseRepository _databaseRepository;
  // StreamSubscription? _authSubscription;

// required AuthBloc authBloc,
  // required DatabaseRepository databaseRepository,
// _databaseRepository = databaseRepository,
  HomePageBloc() : super(HomePageInitial()) {
    on<HomeTabChangeEvent>(_onTabChange);
    // _authBloc = authBloc,
    // on<LoadRoleUser>(_onLoadRoleUser);
    // on<UpdateRoleUser>(_onUpdateRoleUser);

    // _authSubscription = _authBloc.stream.listen((state) {
    //   // if (state.user is AuthUserChanged) {
    //     if (state.user != null) {
    //       print('SE CARGÓ EL LOADPROFILE OBTENIDO DEL AUTHBLOC');
    // //       add(LoadRoleUser(userId: state.user!.uid));
    //     }
    //   }
    // });
  }

  void _onTabChange(HomeTabChangeEvent event, Emitter<HomePageState> emit) {
    emit(BottomNavigationInitial(indexBottomNav: event.newIndex));
  }

// void _onLoadRoleUser(
//   LoadRoleUser event,
//   Emitter<HomePageState> emit,
// ) {
//   _databaseRepository.getUser(event.userId).listen((user) {
//     add(
//       UpdateRoleUser(user: user),
//     );
//   });
// }

// void _onUpdateRoleUser(
//   UpdateRoleUser event,
//   Emitter<HomePageState> emit,
// ) {
//   emit(RoleUserLoaded(user: event.user));
// }

// @override
// Future<void> close() async {
//   _authSubscription?.cancel();
//   super.close();
// }
}
