import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../widgets/custom_loading_screen.dart';
import '../screens.dart';
import 'admin_screens.dart';
import 'dashboard/dashboard_screen.dart';
import 'menu/drawer/custom_drawer.dart';
import 'menu/drawer/custom_drawer_user.dart';

class MenuAdminScreen extends StatefulWidget {
  // static const String routeName = '/menu_admin';
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) {
          // print the status user with the authbloc
          print(BlocProvider.of<AuthBloc>(context).state.status);

          return BlocProvider.of<AuthBloc>(context).state.status ==
                  AuthStatus.unauthenticated
              ? const OnboardingScreen()
              : const MenuAdminScreen();
        });
  }

  const MenuAdminScreen({Key? key}) : super(key: key); //route
  @override
  State<MenuAdminScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MenuAdminScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  initState() {
    drawerIndex = DrawerIndex.HOME_USER;
    screenView = const HomeScreen();
    //user: user
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: AppTheme.nearlyWhite,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          // backgroundColor: AppTheme.nearlyWhite,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.status == AuthStatus.authenticated) {
                return BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const CustomLoadingScreen();
                  }
                  // Future.delayed(Duration.zero, () async {
                  if (state is ProfileLoaded) {
                    if (state.user.role == 'admin') {
                      // Future.delayed(Duration.zero, () async {
                      return DrawerUserController(
                        drawerIsOpen: ((value) => false),
                        drawerWidth: MediaQuery.of(context).size.width * 0.65,
                        screenIndex: drawerIndex,
                        onDrawerCall: (DrawerIndex drawerIndexdata) {
                          changeIndex(drawerIndexdata);
                          /**
                                 * devolución de llamada desde el cajón para reemplazar
                                 * la pantalla según las necesidades del usuario al pasar
                                 * DrawerIndex (índice Enum)
                                 */
                        },
                        screenView: screenView,
                        /**
                               * reemplazamos la vista de pantalla según sea necesario
                               * en las pantallas de inicio de navegación como MyHomePage,
                               * HelpScreen, FeedbackScreen, etc.
                               */
                      );
                      // });
                    } else {
                      return const HomeScreen();
                    }
                  }
                  // });
                  print('///');
                  return const CustomLoadingScreen();
                });
              } else {
                return const CustomLoadingScreen();
              }
            },
          ),
        ),
      ),
    );
  }

//
  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME_USER:
          setState(() {
            screenView = const HomeScreen();
          });
          break;
        case DrawerIndex.DASHBOARD:
          setState(() {
            screenView = DashboardScreen();
          });
          break;
        case DrawerIndex.Product_create:
          setState(() {
            screenView = CreateProductScreen();
          });
          break;
        case DrawerIndex.Product_edit:
          setState(() {
            screenView = const UpdateProductScreen();
          });
          break;
        case DrawerIndex.Product_show:
          setState(() {
            screenView = const ShowProductsScreen();
          });
          break;
        case DrawerIndex.Category_create:
          setState(() {
            screenView = const CreateCategoryScreen();
          });
          break;
        case DrawerIndex.Category_edit:
          setState(() {
            screenView = const UpdateCategoryScreen();
          });
          break;
        case DrawerIndex.Category_show:
          setState(() {
            screenView = const ShowCategoriesScreen();
          });
          break;
        default:
          break;
      }
    }
  }
}
