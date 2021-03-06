import 'package:flutter/material.dart';

import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import '../config/constrants.dart';

class CustomAlertDialog {
// TODO: Customizable alert dialogs contentButtonAndTitle
  static YYDialog contentButtonAndTitle({
    required BuildContext context,
    required Widget content,
    required Widget title,
    double? maxHeight,
    Function? onShowCallBack,
    Function? onDismissCallBack,
  }) {
    return YYDialog().build(context)
      // ..width =
      // ..height = maxHeight ?? maxHeight
      ..margin = const EdgeInsets.symmetric(horizontal: kPaddingM)
      ..backgroundColor =
          Theme.of(context).scaffoldBackgroundColor.withOpacity(1)
      ..borderRadius = 10.0
      ..showCallBack = () {
        print("showCallBack invoke");
        onShowCallBack != null ? onShowCallBack() : null;
      }
      ..dismissCallBack = () {
        print("dismissCallBack invoke");
        onDismissCallBack != null ? onDismissCallBack() : null;
      }
      ..widget(
        Padding(
          padding: const EdgeInsets.all(kPaddingS),
          child: Align(child: title),
        ),
      )
      ..widget(
        Padding(
          padding: const EdgeInsets.all(kPaddingM),
          child: SizedBox(
            height: maxHeight ?? null,
            child: content,
          ),
        ),
      )
      ..animatedFunc = (child, animation) {
        return ScaleTransition(
          child: child,
          scale: Tween(begin: 0.0, end: 1.0).animate(animation),
        );
      }
      ..show();
  }

// TODO: Customizable alert dialogs contentButtonAndTitleWithouthAnimation
  static YYDialog contentButtonAndTitleWithouthAnimation({
    required BuildContext context,
    required Widget content,
    Widget? title,
    double? maxHeight,
    Function? onShowCallBack,
    Gravity? gravity,
    Function? onDismissCallBack,
  }) {
    return YYDialog().build(context)
      // ..width =
      // ..height = 110
      // ..margin = const EdgeInsets.symmetric(horizontal: kPaddingM)
      ..backgroundColor =
          Theme.of(context).scaffoldBackgroundColor.withOpacity(1)
      ..borderRadius = 10.0
      ..showCallBack = () {
        print("showCallBack invoke");
        onShowCallBack != null ? onShowCallBack() : null;
      }
      ..dismissCallBack = () {
        print("dismissCallBack invoke");
        onDismissCallBack != null ? onDismissCallBack() : null;
      }
      ..widget(
        title != null
            ? Padding(
                padding: const EdgeInsets.all(kPaddingS),
                child: Align(child: title),
              )
            : SizedBox(),
      )
      ..widget(
        Padding(
          padding: EdgeInsets.all(maxHeight == null ? kPaddingM : 0.0),
          child: SizedBox(
            height: maxHeight ?? null,
            child: content,
          ),
        ),
      )
      ..gravity = gravity ?? Gravity.bottom
      ..gravityAnimationEnable = true
      ..show();
  }
}
