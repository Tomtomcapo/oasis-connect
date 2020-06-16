import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oasisconnect/Session.dart';
import 'package:oasisconnect/pages/MarksPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ConnectionPage extends StatelessWidget {
  ConnectionPage({Key key, this.title}) : super(key: key);

  final String title;
  bool stayLogged = false;
  static const String routeName = "/login";

  static const String loginUrl =
      "https://oasis.polytech.universite-paris-saclay.fr/prod/bo/core/Router/Ajax/ajax.php?targetProject=oasis_polytech_paris&route=BO\\Connection\\User::login";
  final storage = FlutterSecureStorage();

  // Future to connect
  Future<http.Response> PushLogin(String username, String password) async {
    Map data = {'login': username, 'password': password};
    http.Response response = await http.post(
      loginUrl,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: data,
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed query HTTP post on login');
    }
  }

  /// Show error dialog
  Widget _buildErrorDialog(BuildContext context, String message) {
    return new AlertDialog(
      title: const Text('Erreur de connexion'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Text(message)],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Ok'),
        ),
      ],
    );
  }

  /// Perform a connection with username and password.
  void Connect(String username, String password, BuildContext context,
      {bool storeCredentials = false}) {
    PushLogin(username, password).then((result) {
      var content = json.decode(result.body);
      if (content["success"]) {
        // Store cookie
        var setCookies = result.headers["set-cookie"].split(";");
        for (var setCookie in setCookies) {
          var cookies = setCookie.split(',');
          for (var cookie in cookies) {
            var c = cookie.split("=");
            var key = c[0];
            if (c.length > 1) {
              var value = c[1];
              if (key == "PHPSESSID") {
                Session.PHPSESSID = value;
              } else if (key == "bo_oasis_polytech_parisyear" &&
                  Session.bo_oasis_polytech_parisyear == null ||
                  Session.bo_oasis_polytech_parisyear == "") {
                Session.bo_oasis_polytech_parisyear = value;
              }
            }
          }
        }

        // Set raw cookie in session object
        Session.cookie = result.headers["set-cookie"];

        // Store credentials in keystore or keychain
        if (storeCredentials) {
          storage.write(key: "username", value: username).then((value) {
            storage.write(key: "password", value: password).then((value) {
              Navigator.pushReplacementNamed(context, MarksPage.routeName);
            });
          });
        } else {
          Navigator.pushReplacementNamed(context, MarksPage.routeName);
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildErrorDialog(context, content["text"]),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Controllers for login and password text fields.
    TextEditingController usernameController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();

    // Auto connect
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool('autoconnect') ?? false) {
        print("Trying autoconnect");
        storage.read(key: "username").then((username) {
          storage.read(key: "password").then((password) {
            if (username != null && password != null) {
              Connect(username, password, context);
            }
          });
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Identifiant'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Merci de mentionner un identifiant valide';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Password is required';
                    }
                  },
                ),

                CheckboxListTile(
                  value: stayLogged,
                  onChanged: (bool value) => stayLogged = value,
                  title: new Text('Rester connecté'),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      // Perform user connection and store credentials if needed.
                      var storeCredentials =
                      true; // todo: make this user-defined and not temporary.
                      Connect(usernameController.text, passwordController.text, context,
                          storeCredentials: storeCredentials);
                    },
                    child: Text('Se connecter'),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
