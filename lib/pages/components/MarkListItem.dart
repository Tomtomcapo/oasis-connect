import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oasisconnect/model/Mark.dart';

import '../../main.dart';

class MarkListItem extends StatelessWidget {
  const MarkListItem({
    this.mark
  });

  final Mark mark;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 1.2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Column(children: <Widget>[
                  Align(alignment: Alignment.centerLeft, child: Text(mark.area)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(mark.subject,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                            ))),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(DateFormat.yMMMMd(APP_LOCALE).format(mark.date),
                          style: const TextStyle(
                            color: Colors.black54,
                          )))
                ])),
            Container(
              height: 62,
              width: 76,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: Colors.black26,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(8.0)
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Text(mark.mark < 0.0 ? "N/A" : mark.mark.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24.0,
                          color:  Colors.black54,
                        )),
                  ),
                ),
              ),
            ),
            const Icon(
              Icons.more_vert,
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}