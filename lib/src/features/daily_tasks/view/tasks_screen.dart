import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/empty_screen.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/features/daily_tasks/model/point.dart';
import 'package:tablets/src/features/daily_tasks/repo/tasks_repository_provider.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supervisorAsyncValue = ref.watch(tasksStreamProvider);
    return AppScreenFrame(
      Container(
        padding: const EdgeInsets.all(0),
        child: supervisorAsyncValue.when(
          data: (supervisors) {
            return supervisors.isEmpty ? const EmptyPage() : SalesPoints(supervisors);
          },
          loading: () => const CircularProgressIndicator(), // Show loading indicator
          error: (error, stack) => Text('Error: $error'), // Handle errors
        ),
      ),
      buttonsWidget: const TasksFloatingButtons(),
    );
  }
}

class SalesPoints extends ConsumerWidget {
  const SalesPoints(this.salesPoints, {super.key});
  final List<Map<String, dynamic>> salesPoints;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create a map with unique names as keys and empty lists as values
    Map<String, List<Map<String, dynamic>>> groupedMap = {
      for (var name in salesPoints.map((map) => map['salesmanName'] as String).toSet()) name: []
    };

    // Populate the map with data from the list of maps
    for (var map in salesPoints) {
      String name = map['salesmanName'] as String;
      groupedMap[name]?.add(map);
    }

    // Convert the map to a list of widgets
    List<Widget> widgetList = [];
    groupedMap.forEach((key, value) {
      widgetList.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                padding: const EdgeInsets.all(5),
                child: Text(
                  key, // The name as title
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
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
                    Container(
                        width: 120,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          color: color,
                        ),
                        child: Text(
                          item['customerName'],
                          textAlign: TextAlign.center,
                        )),
                  ],
                );
              }),
              const Divider(), // Divider between groups
            ],
          ),
        ),
      );
    });

    return ListView(
      children: widgetList,
    );
  }

  // Map<String, List<SalesPoint>> getSalesmenPathes(List<Map<String, dynamic>> salesPoints) {
  //   // Step 1: Create a map with unique names as keys and empty lists as values
  //   Map<String, List<SalesPoint>> salesmanPathes = {
  //     for (var name in salesPoints.map((map) => map['name'] as String).toSet()) name: []
  //   };

  //   // Step 2: Populate the map with data from the list of Sales points
  //   for (var map in salesPoints) {
  //     String name = map['name'] as String;
  //     salesmanPathes[name]?.add(SalesPoint.fromMap(map));
  //   }
  //   return salesmanPathes;
  // }
}

class TasksFloatingButtons extends ConsumerWidget {
  const TasksFloatingButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const iconsColor = Color.fromARGB(255, 126, 106, 211);
    return SpeedDial(
      direction: SpeedDialDirection.up,
      switchLabelPosition: false,
      animatedIcon: AnimatedIcons.menu_close,
      spaceBetweenChildren: 10,
      animatedIconTheme: const IconThemeData(size: 28.0),
      visible: true,
      curve: Curves.bounceInOut,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () {
            const salesmanName = '';
            const salesmanDbRef = '';
            const customerName = '';
            const customerDbRef = '';
            final date = DateTime.now();
            const isVisited = false;
            const hasTransaction = false;
            const dbRef = 'qoiurwwr';
            final imageUrls = [defaultImageUrl];
            const name = '';
            final salespoint = SalesPoint(
              salesmanName,
              salesmanDbRef,
              customerName,
              customerDbRef,
              date,
              isVisited,
              hasTransaction,
              dbRef,
              imageUrls,
              name,
            );
            ref.read(tasksRepositoryProvider).addItem(salespoint);
          },
        ),
      ],
    );
  }
}
