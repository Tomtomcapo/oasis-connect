import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oasisconnect/model/Mark.dart';

class MarkListItem extends StatelessWidget {
  const MarkListItem({
    this.mark
  });

  final Mark mark;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.8,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 62,
              width: 76,
              child: Align(
                alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.0,
                        color: Colors.black38,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(6.0)
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(mark.mark < 0.0 ? "N/A" : mark.mark.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24.0,
                            color:  Colors.black54,
                          )),
                    ),
                  ),
                ),
              ),
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
                      child: Text(DateFormat.yMMMMEEEEd().format(mark.date),
                          style: const TextStyle(
                            color: Colors.black54,
                          )))
                ])),
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