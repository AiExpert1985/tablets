import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/empty_screen.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/features/daily_tasks/model/point.dart';
import 'package:tablets/src/features/daily_tasks/repo/tasks_repository_provider.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_db_cache_provider.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  DateTime? selectedDate = DateTime.now();

  Widget _showDatePicker() {
    return SizedBox(
      width: 200,
      child: FormBuilderDateTimePicker(
        initialDate: DateTime.now(),
        name: 'date',
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          labelStyle: TextStyle(color: Colors.red, fontSize: 17),
          // labelText: S.of(context).from_date,
          border: OutlineInputBorder(),
        ),
        inputType: InputType.date,
        format: DateFormat('dd-MM-yyyy'),
        onChanged: (value) {
          selectedDate = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final supervisorAsyncValue = ref.watch(tasksStreamProvider);
    return AppScreenFrame(
      Container(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            _showDatePicker(),
            VerticalGap.xl,
            Expanded(
              child: supervisorAsyncValue.when(
                data: (supervisors) => SalesPoints(supervisors),
                loading: () => const CircularProgressIndicator(), // Show loading indicator
                error: (error, stack) => Text('Error: $error'), // Handle errors
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesPoints extends ConsumerWidget {
  const SalesPoints(this.salesPoints, {super.key});
  final List<Map<String, dynamic>> salesPoints;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // create list of unique salesman names found in firebase for that date
    Set<String> uniqueSalesmanNames = {};
    for (var salesPoint in salesPoints) {
      String salesmanName = salesPoint['salesmanName'] as String;
      uniqueSalesmanNames.add(salesmanName);
    }
    // then add the salesmen not found in that day
    final salesmenDbCache = ref.read(salesmanDbCacheProvider.notifier).data;
    final allSalemenNames = salesmenDbCache.map((salesman) => salesman['name']).toList();
    for (var salesmanName in allSalemenNames) {
      uniqueSalesmanNames.add(salesmanName);
    }

    Map<String, List<Map<String, dynamic>>> groupedMap = {};
    for (var name in uniqueSalesmanNames) {
      groupedMap[name] = []; // Initialize each key with an empty list
    }
    for (var salesPoint in salesPoints) {
      String salesmanName = salesPoint['salesmanName'] as String;
      groupedMap[salesmanName]?.add(salesPoint);
    }

    // Populate the map with data from the list of maps
    for (var map in salesPoints) {
      String name = map['salesmanName'] as String;
      groupedMap[name]?.add(map);
    }

    // Convert the map to a list of widgets
    List<Widget> widgetList = [];
    groupedMap.forEach((key, value) {
      widgetList.add(
        Column(
          children: [
            VerticalGap.xl,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    //TODO logic for adding new task, either by choosing multiple customers or regions
                  },
                ),
                HorizontalGap.l,
                Container(
                  width: 150,
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    key, // The name as title
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (value.isEmpty)
                  Image.asset(
                    'assets/images/empty.png',
                    fit: BoxFit.scaleDown,
                    width: 60,
                  ),
                ...value.map((item) {
                  final color = !item['isVisited']
                      ? Colors.red
                      : item['hasTransaction']
                          ? Colors.green
                          : Colors.amber;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HorizontalGap.l,
                      Stack(
                        children: [
                          Container(
                            width: 140,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              color: color,
                            ),
                            child: Text(
                              item['customerName'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: TextButton(
                                onPressed: () {
                                  ref
                                      .read(tasksRepositoryProvider)
                                      .deleteItem(SalesPoint.fromMap(item));
                                },
                                child: const Text('x'),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                }),
              ],
            )
          ],
        ),
      );
    });

    return ListView(
      children: widgetList,
    );
  }
}
