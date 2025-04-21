import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/daily_tasks/model/point.dart';
import 'package:tablets/src/features/daily_tasks/repo/tasks_repository_provider.dart';

//! This code is only done once to copy pre entered tasks by Jihan and Kinton accountants

Map<int, List<SalesPoint>> createWeeklyTasks(List<Map<String, dynamic>> tasks) {
  Map<int, List<SalesPoint>> weeklyTasks = {};
  for (var taskMap in tasks) {
    SalesPoint task = SalesPoint.fromMap(taskMap);
    int weekday = task.date.weekday;
    // Use putIfAbsent to handle list creation efficiently:
    // 1. Look for the key `weekday` in the map.
    // 2. If the key doesn't exist, create a new empty list `[]` and
    //    associate it with the key `weekday`.
    // 3. Whether the list was newly created or already existed, add the
    //    current `date` to that list.
    weeklyTasks.putIfAbsent(weekday, () => []).add(task);

    /*
    // Alternative approach (more verbose):
    if (groupedDates.containsKey(weekday)) {
      // If the weekday key already exists, add the date to the existing list.
      // The '!' asserts that the key exists, so the value is non-null.
      groupedDates[weekday]!.add(date);
    } else {
      // If the weekday key doesn't exist, create a new list containing
      // the current date and add it to the map.
      groupedDates[weekday] = [date];
    }
    */
  }

  // Return the map containing the grouped dates.
  return weeklyTasks;
}

void copyWeeklyTasks(WidgetRef ref) async {
  final tasksRepo = ref.read(tasksRepositoryProvider);
  final tasks = await tasksRepo.fetchItemListAsMaps();
  final weeklyTasksMap = createWeeklyTasks(tasks);
  weeklyTasksMap.forEach((key, vlaue) {});
}
