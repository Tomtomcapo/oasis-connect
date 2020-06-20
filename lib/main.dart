import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:oasisconnect/routes.dart';
import 'package:intl/date_symbol_data_local.dart';  //for date locale

import 'pages/ConnectionPage.dart';
import 'themes/oasisTheme.dart';

const APP_LOCALE = "fr_FR";

class Application {
  static String version;
}

void main() {
  initializeDateFormatting(APP_LOCALE, null).then((_) => runApp(MyApp()));
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => brightness == Brightness.light
          ? OasisTheme.defaultTheme
          : OasisTheme.darkTheme,
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Oasis Connect',
          theme: theme,
          home: ConnectionPage(title: 'Connexion à OASIS'),
          routes: routes,
        );
      },
    );
  }
}

