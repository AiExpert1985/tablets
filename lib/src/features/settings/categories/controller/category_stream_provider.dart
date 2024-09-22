import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

/// Streaming categorys from firestore 'categories' collection.
/// categoris are steamed separately (I didn't include it in 'categoryController')
///  because it is easy for me to implement
final categoriesStreamProvider =
    StreamProvider<QuerySnapshot<Map<String, dynamic>>>(
  (ref) async* {
    try {
      final querySnapshot =
          FirebaseFirestore.instance.collection('categories').snapshots();
      yield* querySnapshot;
    } catch (e) {
      utils.CustomDebug.print(
          message: 'an error happened while streaming categories',
          stackTrace: StackTrace.current);
    }
  },
);
