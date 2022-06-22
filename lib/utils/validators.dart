// import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

// at least 8 characters / Al menos 8 carácteres
// must contain at least 1 uppercase letter, 1 lowercase letter, and 1 number / debe contener al menos 1 letra mayúscula, 1 letra minúscula y 1 número
// Can contain special characters / Puede contener caracteres especiales
  // r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$',
  static final RegExp _passwordRegExp = RegExp(
    /*
    * Mínimo 1 letra mayúscula.
    * Mínimo 1 letra minúscula.
    * Mínimo 1 carácter especial.
    * Número mínimo 1.
    * Mínimo 8 caracteres.
    * 30 caracteres como máximo (No).
    * */
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#$@!%&*?])[A-Za-z\d#$@!%&*?]{8,}$',
    // r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#$@!%&*?])[A-Za-z\d#$@!%&*?]{8,30}$',
  );

  static bool isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }


  // static isNameValidator(String name) {
  //   if (name.isEmpty) {
  //     return 'Nombre invalido';
  //   } else if (name.length < 3) {
  //     return 'Nombre invalido';
  //   }
  //   return null;
  // }

  static isValidateOnlyTextMinMax({
    required String text,
    required int minCaracter,
    required int maxCarater,
    String messageError = 'Entrada no es valido.',
  }) {
    if (text.isEmpty) {
      return messageError;
    } else if (text.length < minCaracter) {
      return messageError;
    } else if (text.length > maxCarater) {
      return messageError;
    }
    return null;
  }
}
