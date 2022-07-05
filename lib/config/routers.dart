import 'package:bely_boutique_princess/screens/user/map/map_screens.dart';
import 'package:bely_boutique_princess/screens/user/update_user_screen.dart';
import 'package:bely_boutique_princess/utils/terms_conditions.dart';
import 'package:flutter/material.dart';

import '/screens/setting_screen.dart';
import '../models/models.dart';
import '../screens/admin/admin_screens.dart';
import '../screens/user/menu/pruebaAnimate.dart';
import '/screens/screens.dart';

class Routers {
  // generate a setting route
  static Route onGenerateRoute(RouteSettings settings) {
    print('The Route is: ${settings.name}'); // print the route name

    print(settings); // print the routes
    switch (settings.name) {
      // switch the name route on screens
      case '/':
        return MenuAdminScreen.route();
      // return MenuUserScreen.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case MenuAdminScreen.routeName:
        return MenuAdminScreen.route();
      case SplashScreen.routeName:
        return SplashScreen.route();
      case SettingScreen.routeName:
        return SettingScreen.route();
      case OnboardingScreen.routeName:
        return OnboardingScreen.route();
      case ProductScreen.routeName:
        return ProductScreen.route(
            productArguments: settings.arguments as ProductScreenArguments);
      case CreateProductScreen.routeName:
        return CreateProductScreen.route();
      case MapScreen.routeName:
        return MapScreen.route();
      case OpenContainerTransformDemo.routeName:
        return OpenContainerTransformDemo.route();
      case UpdateUserScreen.routeName:
        return UpdateUserScreen.route();
      case TermsConditions.routeName:
        return TermsConditions.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(appBar: AppBar(title: const Text('error'))),
      settings: const RouteSettings(name: '/error'),
    );
  }
}
