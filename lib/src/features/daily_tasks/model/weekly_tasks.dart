import 'package:tablets/src/features/daily_tasks/model/point.dart';

class WeeklyTask {
  String weekDay;
  List<SalesPoint> tasks;
  WeeklyTask({required this.weekDay, required this.tasks});
}
