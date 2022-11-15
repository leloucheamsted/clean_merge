import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///  Theme screens
class Constants {
  static final border = Border.all(
    width: 1,
    color: ColorPalette.btnDisable,
  );
  static final theme = ThemeData(
    // primarySwatch: Colors.blueGrey,
    brightness: Brightness.dark,
    backgroundColor: const Color.fromRGBO(38, 45, 61, 1),
    primaryColor: const Color.fromRGBO(38, 45, 61, 1),
    fontFamily: 'Georgia',
    scaffoldBackgroundColor: const Color(0xFF272d3c),
    dividerColor: ColorPalette.btnDisable,
    // textTheme: TextTheme(),
    dividerTheme: const DividerThemeData(
      color: ColorPalette.btnDisable,
      thickness: 1,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.all(12),
      border: OutlineInputBorder(
        // borderRadius: BorderRadius.circular(LayoutConstants.radiusM),
        borderSide: BorderSide.none,
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: ColorPalette.telloBgColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: ColorPalette.greenStatutColor,
        statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
        statusBarBrightness: Brightness.dark, //<-- For iOS SEE HERE (dark icons)
      ),
      toolbarTextStyle: const TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
      ).bodyText2,
      titleTextStyle: const TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
      ).headline6,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
    ),

    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: ColorPalette.greenStatutColor,
      secondary: ColorPalette.greenStatutColor,
      brightness: Brightness.dark,
      surface: ColorPalette.backgroundBodyColor,
      onSurface: Colors.grey.shade300,
    ),
  )
    ..textTheme.apply(
      bodyColor: ColorPalette.colorText,
      displayColor: ColorPalette.colorText,
      fontFamily: 'poppinsRegular',
    )
    ..floatingActionButtonTheme.copyWith(
      backgroundColor: ColorPalette.greenStatutColor,
    )
    ..snackBarTheme.copyWith(
      actionTextColor: ColorPalette.colorText,
    );
}

/// color Palette constant
class ColorPalette {
  static const Color telloBgColor = Color(0xFF1a212d);
  static const Color statutBarColor = Color.fromRGBO(25, 33, 46, 1);
  static const Color colorText = Color.fromRGBO(255, 255, 255, 1);
  static const Color redStatutColor = Color.fromRGBO(243, 46, 46, 1);
  static const Color greenStatutColor = Color.fromRGBO(107, 174, 51, 1);
  static const Color orangeStatutColor = Color.fromRGBO(255, 146, 36, 1);
  static const Color requestPageColor = Color.fromRGBO(47, 55, 72, 1);
  static const Color btnDisable = Color.fromRGBO(158, 169, 178, 1);
  static const Color blueStatutColor = Color.fromRGBO(68, 122, 193, 1);
  static const Color backgroundBodyColor = Color.fromRGBO(47, 55, 72, 1);
  static const Color grayPopColor = Color.fromRGBO(68, 78, 99, 1);
  static const Color scrollbarColor = Color.fromRGBO(141, 141, 141, 1);
  static const Color toggleUnselectColor = Color.fromRGBO(63, 101, 32, 1);
  static const Color blackColor = Color.fromRGBO(30, 37, 52, 1);
  static const Color selectRecordColor = Color.fromRGBO(107, 174, 51, 0.3);

  static const Color pttIdle = Color(0xFFff6c00);
  static const Color pttTransmitting = Color(0xFFff0d0d);
  static const Color pttReceiving = Color(0xFF7dc144);
}

/// config of application
class Config {
  static const String version = 'V1.0.0-1';
  static const String flagApiUrl = 'https://countryflagsapi.com/svg/';
}

/// Fonts Variables
class Fonts {
  static const String regular = 'poppinsRegular';
  static const String semiBold = 'poppinsSemiBold';
  static const String medium = 'poppinsMedium';
  static const String bold = 'poppinsBold';
  static const String arialRegular = 'ArialRegular';
}

/// Fonts Size
class FontsSize {
  static const double title = 20.0;
  static const double bigText = 18.0;
  static const double normalText = 16.0;
  static const smallText = 14.0;
}

class AssetName {
  static const String telloSocial = 'assets/images/tello_social.svg';
}

/// Icons path and name
class IconsName {
  // static const String telloSocial = 'assets/images/tello_social.svg';
  static const String logoApp = 'assets/icons/homeIcon.svg';
  static const String timelog = 'assets/icons/time.svg';
  static const String previous = 'assets/icons/previous.svg';
  static const String next = 'assets/icons/next.svg';
  static const String editIcon = 'assets/icons/editIcon.svg';
  static const String playIcon = 'assets/icons/playIcon.svg';
  static const String groupIcon = 'assets/icons/groupIcon.svg';
  static const String equalizer = 'assets/icons/equalizer.svg';
  static const String refreshIcon = 'assets/icons/refreshIcon.svg';
  static const String skip = 'assets/icons/skip.svg';
  static const String delete = 'assets/icons/delete.svg';
  static const String message = 'assets/icons/message.svg';
  static const String choiceIcon = 'assets/icons/choice.svg';
  static const String deleteTag = 'assets/icons/deleteTag.svg';
  static const String saveIcon = 'assets/icons/save.svg';
  static const String pingIcon = 'assets/icons/ping.svg';
  static const String send = 'assets/icons/sendicon.svg';
  static const String search = 'assets/icons/search.svg';
  static const String login = 'assets/icons/login.svg';
  static const String parameter = 'assets/icons/parameterLight.svg';
  static const String parameterBold = 'assets/icons/parameterBold.svg';
  static const String arrowLeft = 'assets/icons/arrow-left.svg';
  static const String addGroups = 'assets/icons/groupsadd.svg';
  static const String addmember = 'assets/icons/addmember.svg';
  static const String dropdown = 'assets/icons/dropdown.svg';
  static const String dropup = 'assets/icons/dropup.svg';
  static const String add = 'assets/icons/add.svg';
  static const String pickup = 'assets/icons/pickup.svg';
  static const String throwaway = 'assets/icons/throwaway.svg';
  static const String legs = 'assets/icons/legs.svg';
  static const String home = 'assets/icons/homeIcon.svg';
  static const String speaker = 'assets/icons/speaker.svg';
  static const String profile =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3WEmfJCME77ZGymWrlJkXRv5bWg9QQmQEzw&usqp=CAU';
}
