import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:oasisconnect/routes.dart';

import 'pages/ConnectionPage.dart';
import 'themes/oasisTheme.dart';

void main() {
  runApp(MyApp());
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
          title: 'Flutter Demo Login',
          theme: theme,
          home: ConnectionPage(title: 'Connexion à OASIS'),
          routes: routes,
        );
      },
    );
  }
}

