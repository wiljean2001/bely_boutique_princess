import 'package:flutter/material.dart';

import 'package:bely_boutique_princess/screens/onboarding_auth/onboarding_screen.dart';

import '../blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../generated/l10n.dart';

import '../widgets/custom_bottom_navigation.dart';
import 'user/menu/user_views.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home'; //route name

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        // print the status user with the authbloc
        print(BlocProvider.of<AuthBloc>(context).state.status);
        // validation the status user
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.unauthenticated
            ? const OnboardingScreen()
            : const HomeScreen();
      },
    );
  }

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget>? views; // list of screens to display in the home screen
  @override
  void initState() {
    setListViews(); // initialize
    super.initState();
  }

  void setListViews() {
    views = <Widget>[
      const UserProfileView(),
      const HomeView(),
      const ShoppingCartView(),
    ];
  }

  // Seteo del bottom navigation buttom of app
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        // if home state is initial show loading screen
        if (state is HomePageInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        // if home state is initial show screen depending on the number of the index in the buttom navigation
        if (state is BottomNavigationInitial) {
          return Scaffold(
            extendBody: true,
            body: views![state.indexBottomNav],
            bottomNavigationBar: const CustomBottomNavigationBar(),
          );
        }
        // else error, state error
        return Center(child: Text(S.of(context).Error_displaying_interaces));
      },
    );
  }
}
