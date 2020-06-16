import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasisconnect/Session.dart';
import 'package:oasisconnect/model/Mark.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:oasisconnect/model/Report.dart';
import 'package:oasisconnect/themes/oasisTheme.dart';

import 'components/MarkListItem.dart';

class MarksPage extends StatefulWidget {
  MarksPage({Key key, this.title}) : super(key: key);

  final String title;
  static const String routeName = "/marks";

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<MarksPage> {
  static const String marksUrl =
      "https://oasis.polytech.universite-paris-saclay.fr/prod/bo/core/Router/Ajax/ajax.php?targetProject=oasis_polytech_paris&route=BO\\Layout\\MainContent::load&codepage=MYMARKS";

  void initState() {
    super.initState();
    _report = GetMarks();
  }

  Future<Report> _report;

  // Future to get marks
  Future<Report> GetMarks() async {
    http.Response response = await http.get(
      marksUrl,
      headers: {"cookie": Session.cookiesToString()},
    );
    if (response.statusCode == 200) {
      var document = parse(response.body);

      // Average
      var classSemesterAverage = "semesterAverage";
      var classSemesterAverageElement =
          document.getElementsByClassName(classSemesterAverage).first;
      var semesterAverage =
          classSemesterAverageElement.text.trim().replaceAll(",", ".");

      // Semester info
      var classSemesterInfo = "semesterInfo";
      var classSemesterInfoElement =
          document.getElementsByClassName(classSemesterInfo).first;
      var semesterInfo = classSemesterInfoElement.text;

      // Marks
      List<Mark> marks = [];
      var idMarksTable = "Tests12019";
      var marksTable = document
          .getElementById(idMarksTable)
          .getElementsByTagName("tbody")
          .first;
      for (var child in marksTable.children) {
        var markElement = child.getElementsByTagName("td");
        var markValueStr = markElement[3].text.trimRight().replaceAll(",", ".");
        double markValue;
        try {
          markValue = double.parse(markValueStr);
        } catch (e) {
          markValue = -1.0;
        }
        var mark = Mark(
            area: markElement[0].text.trimRight(),
            subject: markElement[1].text.trimRight(),
            date: new DateTime(2020, 1, 1),
            mark: markValue);
        marks.add(mark);
      }

      return new Report(
          marks: marks,
          semesterAverage: semesterAverage,
          semesterInfo: semesterInfo);
    } else {
      throw Exception('Failed query HTTP post on login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
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
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Version 1.0.0"), // todo: make this dynamic
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Mes notes"),
          actions: <Widget>[
            // action button
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _report = GetMarks();
                });
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70.0),
            child: Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.white),
              child: Container(
                height: 70.0,
                alignment: Alignment.center,
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.white),
                  child: FutureBuilder<Report>(
                      future: _report,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          // todo errors
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                         return  Column(
                           children: <Widget>[
                             Text("Moyenne semestre"),
                             Text((snapshot.data.semesterAverage),
                                 style: TextStyle(
                                     fontWeight: FontWeight.bold, fontSize: 20)),
                             Text(snapshot.data.semesterInfo + " - " + snapshot.data.marks.length.toString() + " note" + (snapshot.data.marks.length > 1 ? "s": "")),
                           ],
                         );
                        }
                      }),

                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: FutureBuilder<Report>(
              future: _report,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  //throw new Exception(snapshot.error.toString());
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(Icons.report_problem),
                          Text("Un erreur est survenue."),
                          Text("Impossible de charger la liste des notes."),
                          Text('Cause : "' + snapshot.error.toString() + '"'),
                        ],
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.marks.length,
                      itemBuilder: (context, index) {
                        return MarkListItem(
                            mark: new Mark(
                                mark: snapshot.data.marks[index].mark,
                                code: "",
                                area: snapshot.data.marks[index].area,
                                subject: snapshot.data.marks[index].subject,
                                date: new DateTime(2019, 12, 13)));
                      });
                }
              }),
        ));
  }
}
