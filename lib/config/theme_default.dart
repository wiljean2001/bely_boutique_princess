import 'package:flutter/material.dart';

ThemeData themeDefault() {
  return ThemeData(
    primaryColor: Colors.pink, // pink
    primarySwatch: Colors.pink, // pink
    primaryColorDark: const Color(0xFF3A5160), // black
    // primaryColorLight: Colors.white,
    // primaryColorLight: const Color(0xFFFEFEFE), // white opaque
    // accentColor: const Color(0xFFE84545),
    scaffoldBackgroundColor: Colors.white, // white
    backgroundColor: const Color(0xFFF4F4F4), //
    iconTheme: const IconThemeData(color: Colors.pink), // pink
    bottomAppBarColor: const Color(0x9ED7D7D7),
    fontFamily: 'SourceSansPro',
    // pageTransitionsTheme: const PageTransitionsTheme(
    //   builders: <TargetPlatform, PageTransitionsBuilder>{
    //     TargetPlatform.android: ZoomPageTransitionsBuilder(),
    //   },
    // ),

    textTheme: const TextTheme(
      headline1: TextStyle(fontFamily: 'SourceSansPro'),
      headline2: TextStyle(fontFamily: 'SourceSansPro'),
      headline3: TextStyle(fontFamily: 'SourceSansPro'),
      headline4: TextStyle(fontFamily: 'SourceSansPro'),
      headline5: TextStyle(fontFamily: 'SourceSansPro'),
      headline6: TextStyle(fontFamily: 'SourceSansPro'),
      bodyText1: TextStyle(fontFamily: 'SourceSansPro'),
      bodyText2: TextStyle(fontFamily: 'SourceSansPro'),
    ),
  );
}
