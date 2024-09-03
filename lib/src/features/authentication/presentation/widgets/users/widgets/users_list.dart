import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/authentication/repository/app_user.dart';
import 'package:tablets/src/features/authentication/repository/firestore_repository.dart';

class UsersList extends ConsumerWidget {
  const UsersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    return FirestoreListView<AppUser>(
        query: firestoreRepository.usersQuery(),
        itemBuilder: (ctx, doc) {
          final appUser = doc.data();
          return ListTile(
            title: Text(appUser.userName),
            subtitle: Text(appUser.email),
          );
        });
  }
}
