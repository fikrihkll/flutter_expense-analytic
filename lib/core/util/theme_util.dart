import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}


class MyTheme {
  static const primaryLight = Color(0xff75b1f6);
  static const primary = Color(0xff2F3A8F);
  static const accent = Color(0xffE5C40E);
  static const accentLight = Color(0xffedd656);
  static const red = Color(0xffF98181);
  static const green = Color(0xff41D6A4);
  static const grayLight = Color(0xffF6F6F6);
  static const grayLight2 = Color(0xffE5E5E5);
  static const graySoft = Color(0xffC1C1C1);
  static const gray = Color(0xff959595);
  static const black = Color(0xff191919);
  static const blackSoft = Color(0xff262626);
  static const blackCard = Color(0xff313131);
  
  static const fontFamily = 'OpenSans';

  static TextStyle titleXlTextStyleLight = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: black);
  static TextStyle titleXlTextStyleDark = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.white);
  static TextStyle titleXlPrimaryTextStyle = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: primaryLight);

  static TextStyle titlePrimaryTextStyleLight = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: black);
  static TextStyle titlePrimaryTextStyleDark = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white);
  static TextStyle titleTextStyleDark = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white
  );
  static TextStyle titleTextStyleLight = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: black
  );

  static TextStyle titleTextStylePrimaryLight = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: primary
  );

  static TextStyle titleTextStylePrimaryDark = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: primaryLight
  );

  static TextStyle titleSmallTextStyleDark = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.white
  );
  static TextStyle titleSmallTextStyleLight = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: black
  );

  static TextStyle normalTextStyle = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
  );

  static TextStyle buttonTextStyle = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      color: Colors.white
  );

  static TextStyle normalTextStyleSoftLight = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      color: gray
  );
  static TextStyle normalTextStyleSoftDark = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      color: graySoft
  );

  static TextStyle smallTextStyleSoftLight = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 10,
      color: gray
  );
  static TextStyle smallTextStyleSoftDark = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 10,
      color: graySoft
  );

  static TextStyle smallTextStyleStrongLight = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 10,
      color: black
  );
  static TextStyle smallTextStyleStrongDark = const TextStyle(
      fontFamily: fontFamily,
      fontSize: 10,
      color: Colors.white
  );

  static ColorScheme darkScheme = const ColorScheme(primary: primaryLight,
      primaryContainer: primary,
      secondary: accent,
      secondaryContainer: accent,
      surface: blackCard,
      background: blackSoft,
      error: red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      brightness: Brightness.dark) ;

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: primaryLight,
    colorScheme: darkScheme,
    cardColor: blackCard,
    textTheme: TextTheme(
        headline1: titleXlTextStyleDark,
        headline2: titleXlPrimaryTextStyle,
        headline3: titlePrimaryTextStyleDark,
        headline4: titleTextStyleDark,
        headline5: titleTextStylePrimaryDark,
        headline6: titleSmallTextStyleDark,
        bodyText1: normalTextStyle,
        bodyText2: normalTextStyleSoftDark,
        subtitle1:  smallTextStyleSoftDark,
        button: buttonTextStyle,
        subtitle2: smallTextStyleStrongDark
    ),
    iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),
  );

  static ColorScheme lightScheme = const ColorScheme(primary: primary,
      primaryContainer: primaryLight,
      secondary: accent,
      secondaryContainer: accentLight,
      surface: Colors.white,
      background: Colors.white,
      error: red,
      onPrimary: black,
      onSecondary: black,
      onSurface: black,
      onBackground: black,
      onError: Colors.white,
      brightness: Brightness.light) ;

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: primaryLight,
    colorScheme: lightScheme,
    textTheme: TextTheme(
        headline1: titleXlTextStyleLight,
        headline2: titleXlPrimaryTextStyle,
        headline3: titlePrimaryTextStyleLight,
        headline4: titleTextStyleLight,
        headline5: titleTextStylePrimaryLight,
        headline6: titleSmallTextStyleLight,
        bodyText1: normalTextStyle,
        bodyText2: normalTextStyleSoftLight,
        subtitle1: smallTextStyleSoftLight,
        button: buttonTextStyle,
        subtitle2: smallTextStyleStrongLight
    ),
    iconTheme: const IconThemeData(color: Colors.white, opacity: 0.8),
  );
}
