import 'package:flutter/material.dart';
import 'package:tablets/src/common_widgets/main_layout/app_bar/main_app_bar.dart';
import 'package:tablets/src/common_widgets/main_layout/drawer/main_drawer.dart';

/// this screen is just a place holder, where i use it for testing
/// before I create the real screen
class EmptyScreen extends StatelessWidget {
  const EmptyScreen({required this.message, super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => const AlertDialog(),
        ),
        child: const Icon(Icons.add),
      ),
      drawer: const MainDrawer(),
      body: Center(child: Text(message, style: const TextStyle(fontSize: 20))),
    );
  }
}
