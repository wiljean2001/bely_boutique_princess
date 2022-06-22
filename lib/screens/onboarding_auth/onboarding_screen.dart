import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth_screens.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const OnboardingScreen(),
    );
  }

  static const List<Tab> tabs = <Tab>[
    // Tab(text: 'Start'),
    Tab(text: 'start'),
    Tab(text: 'Login'),
    Tab(text: 'Register'),
    Tab(text: 'User'),
    Tab(text: 'Pictures'),
  ];

  const OnboardingScreen({Key? key}) : super(key: key);

  // Seteo del bottom navigation opcions del sistema operativo
  // custom system bar
  // static const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
  //   systemNavigationBarColor: Color(0xfff4ced9),
  //   // systemNavigationBarColor: Colors.transparent,
  //   systemNavigationBarIconBrightness: Brightness.light,
  //   // systemNavigationBarDividerColor: Colors.transparent,
  //   systemNavigationBarDividerColor: Color(0xfff4ced9),
  // );

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    return DefaultTabController(
      animationDuration: const Duration(seconds: 1),
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;

        return Scaffold(
          extendBodyBehindAppBar: true,
          // appBar: AppBar(
          //   automaticallyImplyLeading: false,
          //   elevation: 0,
          //   backgroundColor: Colors.transparent,
          //   // actions: [
          //   //   TextButton(onPressed: () {}, child: Text("Saltar")),
          //   // ],
          // ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(), // never scroll
            // viewportFraction: 5,
            children: [
              StartScreen(tabController: tabController),
              LoginScreen(tabController: tabController),
              RegisterScreen(tabController: tabController),
              RegisterUserScreen(tabController: tabController),
              PicturesScreen(tabController: tabController)
            ],
          ),
        );
      }),
    );
  }
}
