
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasisconnect/themes/oasisTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConnectionPage.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('OASIS Connect'),
            decoration: BoxDecoration(
              color: OasisTheme.defaultTheme.primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.format_list_numbered),
            title: Text('Mes notes'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(
            color: Colors.black26,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text('Se deconnecter'),
            onTap: () {

              SharedPreferences.getInstance().then((prefs) {
                prefs.setBool('autoconnect', false);
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, ConnectionPage.routeName);
              });


            },
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Version 1.1.0"), // todo: make this dynamic
          )
        ],
      ),
    );
  }

}


