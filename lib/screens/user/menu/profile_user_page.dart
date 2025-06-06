import 'package:bely_boutique_princess/blocs/theme.dart';
import 'package:bely_boutique_princess/config/constrants.dart';
import 'package:bely_boutique_princess/config/responsive.dart';
import 'package:bely_boutique_princess/screens/user/map/map_screens.dart';
import 'package:bely_boutique_princess/utils/open_all.dart';
import 'package:bely_boutique_princess/widgets/custom_app_bar_avatar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bely_boutique_princess/models/user_model.dart';

import '../../../blocs/blocs.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../repositories/auth/auth_repository.dart';
import '../../setting_screen.dart';
import 'pruebaAnimate.dart';
import 'package:provider/provider.dart';

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
          return getProfileLoaded(
            edad: edad,
            usuario: state.user,
          ); // widget show profile
        }
        return Center(child: Text(S.of(context).error_desc));
      },
    );
  }
}

class getProfileLoaded extends StatefulWidget {
  const getProfileLoaded({
    Key? key,
    required this.edad,
    required this.usuario,
  }) : super(key: key);

  final int edad;
  final User usuario;

  @override
  State<getProfileLoaded> createState() => _getProfileLoadedState();
}

class _getProfileLoadedState extends State<getProfileLoaded> {
  BoxFit imageBoxFit = BoxFit.fitHeight; // image box fit for photo user

  @override
  Widget build(BuildContext context) {
    final ThemeChanger theme = Provider.of<ThemeChanger>(context);
    ThemeData themeData = theme.getTheme(); // get theme
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // custom app bar
          TransitionAppBar(
            textTheme: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                ),
            avatar: GestureDetector(
              onTap: () {
                if (imageBoxFit == BoxFit.fitHeight) {
                  imageBoxFit = BoxFit.fitWidth;
                } else {
                  imageBoxFit = BoxFit.fitHeight;
                }
                setState(() {});
              },
              child: widget.usuario.image.isNotEmpty
                  ? Image.network(
                      widget.usuario.image,
                      fit: imageBoxFit,
                      alignment: Alignment.center,
                    )
                  : Image.asset(Assets.imagesLogoTextoRosa),
            ),
            title: '@${widget.usuario.name}',
            extent: Responsive.isMobile(context) ? 280 : 500,
          ),
          // show info (Year old);
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
                              const Text(
                                'Edad',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.edad.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // contents (buttons - options)
                  Body(themeData: themeData),
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
  final ThemeData themeData;
  const Body({
    Key? key,
    required this.themeData,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    // List options
    List<ButtonProfile> listButtons = [
      // option visit
      ButtonProfile(
        title: S.of(context).option_visit,
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
      // option settings
      ButtonProfile(
        title: S.of(context).title_settings_screen,
        onPressed: () => Navigator.pushNamed(context, SettingScreen.routeName),
      ),
      // option map
      ButtonProfile(
        title: S.of(context).title_map_screen,
        onPressed: () {
          Navigator.pushNamed(context, MapScreen.routeName);
        },
      ),
      // option sign out
      ButtonProfile(
        title: S.of(context).option_sign_out,
        onPressed: () {
          context.read<AuthRepository>().signOut();
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          );
        },
      ),
    ];
    // show - insert all options on screen
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: listButtons.map(
        (e) {
          return CustomButtonProfile(
            title: e.title,
            onPressed: e.onPressed,
            themeData: widget.themeData,
          );
        },
      ).toList(),
    );
  }
}

class ButtonProfile {
  final String title;
  final Function onPressed;

  ButtonProfile({required this.title, required this.onPressed});
}
// widget custom button
class CustomButtonProfile extends StatelessWidget {
  final String title;
  final Function onPressed;
  final ThemeData themeData;
  const CustomButtonProfile({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.themeData,
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
              style: TextStyle(
                color: ThemeData.dark() == themeData
                    ? Colors.white
                    : Theme.of(context).primaryColorDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
          urlWeb: FACEBOOK_BELY,
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
          whatsapp: PHONE_BELY,
          whatsappMessage: "",
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
                          urlWeb: urlWeb!,
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
