import '../blocs/blocs.dart';
import '/blocs/home/home_page_bloc.dart';
import 'package:flutter/material.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final homePageBloc = context.read<HomePageBloc>();

    List<Widget> _listItems = [
      const Icon(Icons.account_circle, size: 30),
      const Icon(Icons.home, size: 30),
      const Icon(Icons.shopping_cart, size: 30),
    ];

    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        if (state is BottomNavigationInitial) {
          return Theme(
            data: Theme.of(context)
                .copyWith(iconTheme: const IconThemeData(color: Colors.white)),
            child: CurvedNavigationBar(
              index: state.indexBottomNav,
              height: 55,
              backgroundColor: Colors.transparent,
              // buttonBackgroundColor: Colors.black,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 420),
              color: Theme.of(context).primaryColor,
              items: _listItems,
              onTap: (index) =>
                  homePageBloc.add(HomeTabChangeEvent(newIndex: index)),
            ),
          );
        }
        return const Text("Error");
      },
    );
  }
}
