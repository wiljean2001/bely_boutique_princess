import 'package:bely_boutique_princess/config/responsive.dart';
import 'package:bely_boutique_princess/screens/admin/roles/role_screen.dart';
import 'package:bely_boutique_princess/screens/admin/size/size_screen.dart';
import 'package:bely_boutique_princess/screens/admin/type_product/type_product_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../widgets/custom_loading_screen.dart';
import '../screens.dart';
import 'admin_screens.dart';
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
          // validation user status
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
    drawerIndex = DrawerIndex.HOME_USER; // index of first screen
    screenView = const HomeScreen(); // show as first screen
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
                        drawerWidth: Responsive.isMobile(context)
                            ? MediaQuery.of(context).size.width * 0.65
                            : MediaQuery.of(context).size.width * 0.4,
                        screenIndex: drawerIndex,
                        onDrawerCall: (DrawerIndex drawerIndexdata) {
                          changeIndex(drawerIndexdata);

                          // devolución de llamada desde el cajón para reemplazar
                          // la pantalla según las necesidades del usuario al pasar
                          // DrawerIndex (índice Enum)

                          // callback from the drawer to replace the display
                          // based on the user's needs when passing
                          // DrawerIndex(Enum index).
                        },
                        screenView: screenView,

                        // reemplazamos la vista de pantalla según sea necesario
                        // en las pantallas de inicio de navegación como MyHomePage,
                        // HelpScreen, FeedbackScreen, etc.

                        // we replace the screen view as needed
                        // on navigation home screens like MyHomePage,
                        // HelpScreen, FeedbackScreen, etc.
                      );
                      // });
                    } else {
                      return const HomeScreen();
                    }
                  }
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

  // method to change screen and index
  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME_USER: // home screen
          setState(() {
            screenView = const HomeScreen();
          });
          break;
        case DrawerIndex.DASHBOARD: // dashboard - no implemented
          setState(() {
            // screenView = DashboardScreen();
          });
          break;
        case DrawerIndex.ROLE: // role screen
          setState(() {
            screenView = const RoleScreen();
          });
          break;
        case DrawerIndex.TYPEPRODUCT: // typroduct screen
          setState(() {
            screenView = const TypeProductScreen();
          });
          break;
        case DrawerIndex.SIZES: // Sizes product screen
          setState(() {
            screenView = const SizeScreen();
          });
          break;
        case DrawerIndex.Product_create: // Create product screen
          setState(() {
            screenView = CreateProductScreen();
          });
          break;
        case DrawerIndex.Product_edit: // Update product screen
          setState(() {
            screenView = const UpdateProductScreen();
          });
          break;
        case DrawerIndex.Product_show: // Show all product screen
          setState(() {
            screenView = const ShowProductsScreen();
          });
          break;
        case DrawerIndex.Category_create: // Create categories screen
          setState(() {
            screenView = const CreateCategoryScreen();
          });
          break;
        case DrawerIndex.Category_edit: // Update categories screen
          setState(() {
            screenView = const UpdateCategoryScreen();
          });
          break;
        case DrawerIndex.Category_show: // Show all categories screen
          setState(() {
            screenView = const ShowCategoriesScreen();
          });
          break;
        case DrawerIndex.Orders: // show orders screen, search by id user
          setState(() {
            screenView = const ScreenOrderDetails();
          });
          break;
        default:
          break;
      }
    }
  }
}
