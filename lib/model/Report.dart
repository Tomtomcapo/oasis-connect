import 'Mark.dart';

class Report extends Object {
  const Report({
    this.marks,
    this.averages,
    this.semesterAverage,
    this.semesterInfo
  });

  final List<Mark> marks;
  final List<Mark> averages;
  final double semesterAverage;
  final String semesterInfo;
}