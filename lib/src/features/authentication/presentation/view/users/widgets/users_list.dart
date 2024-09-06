import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/authentication/data/app_user.dart';
import 'package:tablets/src/features/authentication/data/firestore_repository.dart';

class UsersList extends ConsumerWidget {
  const UsersList({super.key});

  void updateUser(WidgetRef ref, String uid, String userName, String userEmail,
      String imageUrl, String privilage) {
    ref.read(firestoreRepositoryProvider).updateUser(
          uid: uid,
          userName: userName,
          email: userEmail,
          imageUrl: imageUrl,
          privilage: privilage,
        );
  }

  void deleteUser(WidgetRef ref, String uid) {
    ref.read(firestoreRepositoryProvider).deleteUser(uid: uid);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    return FirestoreListView<ApplicationUser>(
        query: firestoreRepository.usersQuery(),
        itemBuilder: (ctx, doc) {
          final appUser = doc.data();
          final uid = doc.id;
          return Dismissible(
            key: Key(doc.id),
            background: const ColoredBox(color: Colors.red),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              deleteUser(ref, uid);
            },
            child: ListTile(
              title: Text(appUser.userName),
              subtitle: Text(appUser.email),
              onTap: () => updateUser(ref, uid, 'newName', 'newEmail',
                  'newImageUrl', 'newPrivilage'),
            ),
          );
        });
  }
}
