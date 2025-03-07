import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/features/daily_tasks/repo/tasks_repository_provider.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supervisorAsyncValue = ref.watch(tasksStreamProvider);
    return AppScreenFrame(
      buttonsWidget: const TasksFloatingButtons(),
      Container(
        padding: const EdgeInsets.all(0),
        child: supervisorAsyncValue.when(
          data: (supervisors) {
            return const Text('hi');
          },
          loading: () => const CircularProgressIndicator(), // Show loading indicator
          error: (error, stack) => Text('Error: $error'), // Handle errors
        ),
      ),
    );
  }
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
          onTap: () {},
        ),
      ],
    );
  }
}
