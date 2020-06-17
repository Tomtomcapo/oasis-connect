import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oasisconnect/Session.dart';
import 'package:oasisconnect/main.dart';
import 'package:oasisconnect/model/Mark.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:oasisconnect/model/Report.dart';
import 'package:oasisconnect/pages/ConnectionPage.dart';
import 'package:oasisconnect/pages/components/SideMenu.dart';
import 'package:oasisconnect/themes/oasisTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/MarkListItem.dart';

class MarksPage extends StatefulWidget {
  MarksPage({Key key, this.title}) : super(key: key);

  final String title;
  static const String routeName = "/marks";

  @override
  _MarksPageState createState() => _MarksPageState();
}

enum Sort { date_asc, date_desc, mark_asc, mark_desc, name_asc, name_desc }

class _MarksPageState extends State<MarksPage> {
  static const String marksUrl =
      "https://oasis.polytech.universite-paris-saclay.fr/prod/bo/core/Router/Ajax/ajax.php?targetProject=oasis_polytech_paris&route=BO\\Layout\\MainContent::load&codepage=MYMARKS";

  Sort _sortMethod = Sort.date_desc;
  Future<Report> _report;

  void initState() {
    super.initState();
    _report = GetMarks();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Actualiser':
        setState(() {
          _report = GetMarks();
        });
        break;
      case 'Partager':
        break;
    }
  }

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
      var semesterAverage;
      try {
        semesterAverage = double.parse(
            classSemesterAverageElement.text.trim().replaceAll(",", "."));
      } catch (e) {
        semesterAverage = -1.0;
      }

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
            date:
                DateFormat.yMMMMd(APP_LOCALE).parse(markElement[2].text.trim()),
            mark: markValue);
        marks.add(mark);
      }

      print("TRI : ");

      // Sort marks
      switch (_sortMethod) {
        case Sort.date_asc:
          marks.sort((a, b) => a.date.compareTo(b.date));
          break;
        case Sort.date_desc:
          marks.sort((a, b) => b.date.compareTo(a.date));
          break;
        case Sort.mark_asc:
          marks.sort((a, b) => a.mark.compareTo(b.mark));
          break;
        case Sort.mark_desc:
          marks.sort((a, b) => b.mark.compareTo(a.mark));
          break;
        case Sort.name_asc:
          marks.sort((a, b) => a.area.compareTo(b.area));
          break;
        case Sort.name_desc:
          marks.sort((a, b) => b.area.compareTo(a.area));
          break;
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
        drawer: SideMenu(),
        appBar: AppBar(
          title: Text("Mes notes"),
          actions: <Widget>[
            PopupMenuButton(
              child: const Icon(Icons.sort),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio(
                        groupValue: _sortMethod,
                        onChanged: (Sort value) {
                          setState(() {
                            _sortMethod = value;
                            _report = GetMarks();
                          });
                        },
                        value: Sort.name_asc,
                      ),
                      Text("Par matière (A à Z)"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio(
                        groupValue: _sortMethod,
                        onChanged: (Sort value) {
                          setState(() {
                            _sortMethod = value;
                            _report = GetMarks();
                          });
                        },
                        value: Sort.name_desc,
                      ),
                      Text("Par matière (Z à A)"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio(
                        groupValue: _sortMethod,
                        onChanged: (Sort value) {
                          setState(() {
                            _sortMethod = value;
                            _report = GetMarks();
                          });
                        },
                        value: Sort.date_asc,
                      ),
                      Text("Du plus récent au plus vieux"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio(
                        groupValue: _sortMethod,
                        onChanged: (Sort value) {
                          setState(() {
                            _sortMethod = value;
                            _report = GetMarks();
                          });
                        },
                        value: Sort.date_desc,
                      ),
                      Text("Du plus vieux au plus récent"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio(
                        groupValue: _sortMethod,
                        onChanged: (Sort value) {
                          setState(() {
                            _sortMethod = value;
                            _report = GetMarks();
                          });
                        },
                        value: Sort.mark_asc,
                      ),
                      Text("Par note (croissant)"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio(
                        groupValue: _sortMethod,
                        onChanged: (Sort value) {
                          setState(() {
                            _sortMethod = value;
                            _report = GetMarks();
                          });
                        },
                        value: Sort.mark_desc,
                      ),
                      Text("Par note (décroissant)"),
                    ],
                  ),
                ),
              ],
            ),
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Actualiser', 'Partager'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
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
                          return Column(
                            children: <Widget>[
                              Text("Moyenne semestre"),
                              Text(
                                  snapshot.data.semesterAverage
                                      .toStringAsFixed(3),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Text(snapshot.data.semesterInfo +
                                  " - " +
                                  snapshot.data.marks.length.toString() +
                                  " note" +
                                  (snapshot.data.marks.length > 1 ? "s" : "")),
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
                                date: snapshot.data.marks[index].date));
                      });
                }
              }),
        ));
  }
}
