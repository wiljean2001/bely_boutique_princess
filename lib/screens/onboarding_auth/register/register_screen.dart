import 'package:flutter/material.dart';

import '../../../config/responsive.dart';
import '../../../generated/l10n.dart';
import '/widgets/curved_widget.dart';

import 'register_form.dart';

class RegisterScreen extends StatelessWidget {
  final TabController tabController;
  const RegisterScreen({Key? key, required this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        physics: const BouncingScrollPhysics(),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            CurvedWidget(
              //curved widget with logo
              chield: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: Responsive.isMobile(context) ? 100 : 150,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.white70.withOpacity(0.5),
                      ]),
                ),
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: Responsive.isMobile(context) ? 300 : 450,
                ),
                // height: Responsive.isMobile(context) ? 300 : 350,
                child: Text(
                  S.of(context).title_register_screen,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width * 0.85
                    : 700,
              ),
              margin: EdgeInsets.only(
                top: Responsive.isMobile(context) ? 300 : 330,
              ),
              height: Responsive.isMobile(context) ? 300 : 350,
              child: RegisterForm(tabController: tabController),
            ),
          ],
          //     ),
          //   ),
        ),
      ),
    );
  }
}
