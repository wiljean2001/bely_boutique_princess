// screen Start

import 'package:bely_boutique_princess/config/responsive.dart';
import 'package:flutter/material.dart';

import '../../config/constrants.dart';
import '../../generated/assets.dart';
import '../../generated/l10n.dart';
import '../../widgets/curved_widget.dart';
import '../../widgets/custom_button_gradiant.dart';

class StartScreen extends StatelessWidget {
  final TabController tabController;

  const StartScreen({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.width);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(225, 242, 203, 208),
            Color(0xfff4ced9),
          ],
        ),
      ),
      height: double.infinity,
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            CurvedWidget(
              mode: 2,
              //curved widget with logo
              chield: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.5),
                    ],
                  ),
                ),
                constraints: BoxConstraints(
                  maxHeight: Responsive.isMobile(context) ? 400 : 500,
                ),
                width: double.infinity,
                child: const Image(
                  image: AssetImage(Assets.imagesLogoCoronaTexto),
                  // alignment: Alignment.topCenter,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: Responsive.isMobile(context) ? 400 : 500),
              alignment: Alignment.center,
              height: Responsive.isMobile(context) ? 250 : 300,
              // constraints: BoxConstraints(ma),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    S.of(context).title_app,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
                    child: Text(
                      S.of(context).description_app,
                      style: Responsive.isMobile(context)
                          ? Theme.of(context).textTheme.bodyText2
                          : Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  CustomButtonGradiant(
                    text: Text(
                      S.of(context).bttn_start,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.start,
                      color: Colors.white,
                    ),
                    height: 55,
                    width: 200,
                    onPressed: () => tabController.animateTo(
                      tabController.index + 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
