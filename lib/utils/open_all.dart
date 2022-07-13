import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

import '../config/constrants.dart';

abstract class OpenAll {
  // Open URL
  static openUrl({required String urlWeb}) async {
    final Uri url = Uri.parse(urlWeb);
    try {
      if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e); // error
    }
  }

  static openwhatsapp({
    String whatsapp = PHONE_BELY,
    required String message,
  }) async {
    // var whatsapp = "+919144040888";
    try {
      if (Platform.isIOS) {
        var whatappURLIos =
            Uri.parse("https://wa.me/$whatsapp?text=${Uri.parse(message)}");
        if (!await launchUrl(whatappURLIos,
            mode: LaunchMode.externalNonBrowserApplication)) {
          throw 'Could not launch $whatappURLIos';
        }
      }
      if (Platform.isAndroid) {
        var whatsappURlAndroid =
            Uri.parse("whatsapp://send?phone=" + whatsapp + "&text=$message");
        if (!await launchUrl(whatsappURlAndroid,
            mode: LaunchMode.externalNonBrowserApplication)) {
          throw 'Could not launch $whatsappURlAndroid';
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
