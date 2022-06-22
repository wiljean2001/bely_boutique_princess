import 'package:bely_boutique_princess/config/responsive.dart';
import 'package:bely_boutique_princess/utils/open_all.dart';
import 'package:bely_boutique_princess/widgets/custom_app_bar_avatar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

import 'package:bely_boutique_princess/models/user_model.dart';

import '../../../blocs/blocs.dart';
import '../../../generated/l10n.dart';
import '../../../repositories/auth/auth_repository.dart';
import '../../setting_screen.dart';
import 'pruebaAnimate.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ProfileLoaded) {
          final edad =
              DateTime.now().year - state.user.dateOfBirth!.toDate().year;
          return getProfileLoaded(edad: edad, usuario: state.user);
        }
        return Center(child: Text(S.of(context).error_desc));
      },
    );
  }
}

class getProfileLoaded extends StatelessWidget {
  const getProfileLoaded({
    Key? key,
    required this.edad,
    required this.usuario,
  }) : super(key: key);

  final int edad;
  final User usuario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(title: S.of(context).AppTitle, hasActions: false),
      body: CustomScrollView(
        slivers: [
          TransitionAppBar(
            textTheme: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                ),
            avatar: usuario.image.isNotEmpty
                ? Image.network(
                    usuario.image,
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.center,
                  )
                : Image.asset('assets/images/profile_pic.png'),
            title: '@${usuario.name}',
            extent: Responsive.isMobile(context) ? 280 : 500,
          ),
          SliverToBoxAdapter(
            child: Container(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    // width: double.infinity,
                    height: 80,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                'Edad',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              Text(
                                edad.toString(),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorLight),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Body(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    List<ButtonProfile> listButtons = [
      ButtonProfile(
        title: 'Visitanos',
        onPressed: () async => await showDialog(
          context: context,
          // barrierColor: Colors.transparent,
          useRootNavigator: true,
          builder: (BuildContext context) => const AlertDialog(
            contentPadding: EdgeInsets.all(0),
            alignment: Alignment.center,
            content: PagesVisit(),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      ButtonProfile(
        title: 'Configuraciones',
        onPressed: () => Navigator.pushNamed(context, SettingScreen.routeName),
      ),
      ButtonProfile(
        title: 'Ayuda',
        onPressed: () {
          Navigator.pushNamed(context, OpenContainerTransformDemo.routeName);
          // Fluttertoast.showToast(
          // msg: "Tap a ayuda",
          // toastLength: Toast.LENGTH_SHORT,
          // gravity: ToastGravity.BOTTOM,
          // timeInSecForIosWeb: 1,
          // backgroundColor: Colors.grey,
          // textColor: Colors.white,
          // fontSize: 16.0);
        },
      ),
      ButtonProfile(
        title: 'Cerrar Sesion',
        onPressed: () {
          RepositoryProvider.of<AuthRepository>(context).signOut();
          context.read<AuthBloc>().add(const AuthUserChanged(user: null));
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          );
        },
      ),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: listButtons
          .map(
            (e) => CustomButtonProfile(title: e.title, onPressed: e.onPressed),
          )
          .toList(),
    );
  }
}

class ButtonProfile {
  final String title;
  final Function onPressed;

  ButtonProfile({required this.title, required this.onPressed});
}

class CustomButtonProfile extends StatelessWidget {
  final String title;
  final Function onPressed;
  const CustomButtonProfile({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 25 : 40,
          vertical: Responsive.isMobile(context) ? 10 : 15),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: Responsive.isMobile(context) ? 50 : 60,
          child: MaterialButton(
            onPressed: () async => onPressed(),
            child: Text(
              title,
              style: TextStyle(color: Theme.of(context).primaryColorDark),
            ),
          ),
        ),
      ),
    );
  }
}
// SliverAppBar(
//   pinned: true,
//   snap: false,
//   // backgroundColor: Colors.transparent,
//   floating: false,
//   // brightness: ,
//   expandedHeight: 280,
//   flexibleSpace: FlexibleSpaceBar(
//     centerTitle: true,
//     title: Text(
//       '@${usuario.name}',
//       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//         fontSize: 16,
//         shadows: [
//           Shadow(
//               color: Theme.of(context).primaryColor, blurRadius: 10)
//         ],
//       ),
//     ),
//     // collapseMode: CollapseMode.none,
//     background: Image.network(
//       usuario.imageUrls[0],
//       fit: BoxFit.fitWidth,
//       alignment: Alignment.center,
//     ),
//   ),
// ),
// actions: <Widget>[
//   TextButton(
//     onPressed: () => Navigator.pop(context, 'Cancel'),
//     child: const Text('Cancel'),
//   ),
//   TextButton(
//     onPressed: () => Navigator.pop(context, 'OK'),
//     child: const Text('OK'),
//   ),
// ],
// Fluttertoast.showToast(
//     msg: "Tab a visitanos",
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 1,
//     backgroundColor: Colors.grey,
//     textColor: Colors.white,
//     fontSize: 16.0);

class PagesVisit extends StatelessWidget {
  const PagesVisit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> cardPages = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CardVisit(
          backgroundColor: Theme.of(context).primaryColorLight,
          title: 'Facebook',
          descript: 'Visítanos en Facebook dandole click al botón',
          icon: const Icon(Icons.facebook),
          image: 'assets/images/facebook_64.png',
          urlWeb: 'https://www.facebook.com/belyboutiqueprincess',
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CardVisit(
          backgroundColor: Theme.of(context).primaryColor,
          title: 'Whatsapp',
          descript: 'Visítanos en Whatsapp dandole click al botón',
          icon: const Icon(Icons.whatsapp),
          image: 'assets/images/whatsapp_64.png',
          whatsapp: "+51953433761",
          whatsappMessage: "Hola",
        ),
      ),
    ];

    return SizedBox(
      width: 200,
      height: 250,
      child: PageView(
        physics: const BouncingScrollPhysics(),
        controller: PageController(viewportFraction: 0.8),
        children: cardPages,
      ),
    );
  }
}

class CardVisit extends StatelessWidget {
  final String title;
  final String? descript;
  final Icon? icon;
  final String? image;
  final Color? backgroundColor;
  final String? urlWeb;
  final String? whatsapp;
  final String? whatsappMessage;

  // final Function onPressed;

  const CardVisit({
    Key? key,
    required this.title,
    this.descript,
    this.icon,
    this.backgroundColor = Colors.red,
    this.image,
    this.urlWeb,
    this.whatsapp,
    this.whatsappMessage,

    // required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor!,
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            descript != null
                ? Text(
                    descript!,
                    textAlign: TextAlign.center,
                  )
                : const Text(''),
            // icon != null ? icon! : const Text(''),
            const SizedBox(height: 10),
            image != null
                ? MaterialButton(
                    onPressed: () {
                      if (urlWeb != null) {
                        OpenAll.openUrl(
                          urlWeb:
                              'https://www.facebook.com/belyboutiqueprincess',
                        );
                      } else if (whatsapp != null && whatsappMessage != null) {
                        OpenAll.openwhatsapp(
                          whatsapp: whatsapp!,
                          message: whatsappMessage!,
                        );
                      }
                    },
                    child: Image(
                      image: AssetImage(image!),
                    ),
                  )
                : const Text(''),
          ],
        ),
      ),
    );
  }
}
