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
        return ProductScreen.route(product: settings.arguments as Product);
      case CreateProductScreen.routeName:
        return CreateProductScreen.route();
      case OpenContainerTransformDemo.routeName:
        return OpenContainerTransformDemo.route();
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
