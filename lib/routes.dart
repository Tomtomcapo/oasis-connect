import 'package:flutter/cupertino.dart';
import 'package:oasisconnect/pages/ConnectionPage.dart';
import 'package:oasisconnect/pages/MarksPage.dart';

var routes = <String, WidgetBuilder>{
  ConnectionPage.routeName: (BuildContext context) => new ConnectionPage(title: "Connexion au service OASIS"),
  MarksPage.routeName : (BuildContext context) => new MarksPage(title: "Mes notes"),
};