import 'package:flutter/material.dart';

import 'package:bely_boutique_princess/screens/onboarding_auth/onboarding_screen.dart';

import '../blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../generated/l10n.dart';

import '../widgets/custom_bottom_navigation.dart';
import 'user/menu/user_views.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home'; //route

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        // print the status user with the authbloc
        print(BlocProvider.of<AuthBloc>(context).state.status);

        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.unauthenticated
            ? const OnboardingScreen()
            : const HomeScreen();
      },
    );
  }

  const HomeScreen({
    Key? key,
    // required this.user,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget>? views;
  @override
  void initState() {
    setListViews();
    super.initState();
  }

  void setListViews() {
    views = <Widget>[
      const UserProfileView(),
      const HomeView(),
      const ShoppingCartView(),
    ];
  }

  // Seteo del bottom navigation opcions del sistema operativo
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        if (state is HomePageInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is BottomNavigationInitial) {
          return Scaffold(
            extendBody: true,
            body: views![state.indexBottomNav],
            bottomNavigationBar: const CustomBottomNavigationBar(),
          );
        }
        return Center(child: Text(S.of(context).Error_displaying_interaces));
      },
    );
  }
}
