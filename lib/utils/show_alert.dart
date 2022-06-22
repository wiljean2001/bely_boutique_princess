import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowAlert {
  static Future<void> showMessage({
    required String msg,
    Color backGroundColor = Colors.white,
    Color textColor = Colors.black,
  }) async {
    await Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: backGroundColor,
        textColor: textColor,
        fontSize: 16.0);
  }

  static Future<void> showSuccessSnackBar(BuildContext context,
      {String message = '¡Operación exitosa!.'}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green.shade400,
        content: Text(message),
      ),
    );
  }

  static Future<void> showErrorSnackBar(BuildContext context,
      {String message = 'Operación fallida: Ocurrió un error.'}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.pink,
        content: Text(message),
      ),
    );
  }

  static Future<void> showAlertSnackBar(BuildContext context,
      {String message = 'Operación en proceso...'}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.yellow,
        content: Text(message,
            style: TextStyle(color: Theme.of(context).primaryColorDark)),
      ),
    );
  }
}
