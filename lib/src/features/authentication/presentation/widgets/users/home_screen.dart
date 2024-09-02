import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/reversed_logout_icon.dart';
import 'package:tablets/src/features/authentication/presentation/widgets/users/add_user_popup.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معلومات المستخدمين',
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const ReversedLogoutIcon()),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddUserPopup();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text('هنا سيتم اضافة اسماء المستخدمين'),
      ),
    );
  }
}
