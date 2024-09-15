import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropdownWithFirebase extends ConsumerWidget {
  final FirebaseFirestore firestore;

  const DropdownWithFirebase({required this.firestore, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropdownProvider = ref.watch(dropdownStateProvider);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: firestore.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final items = snapshot.data!.docs.map((doc) {
          return doc[
              'productCategory']; // Replace 'item_name' with your actual field name
        }).toList();

        return DropdownButtonFormField<String>(
          value: dropdownProvider.selectedValue,
          onChanged: (value) {
            ref
                .read(dropdownStateProvider.notifier)
                .updateSelectedValue(value!);
          },
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        );
      },
    );
  }
}

class DropdownState extends StateNotifier<DropdownStateData> {
  DropdownState(this.initialItems) : super(DropdownStateData(initialItems));

  final List<String> initialItems;

  void updateSelectedValue(String newValue) {
    state = state.copyWith(selectedValue: newValue);
  }
}

class DropdownStateData {
  final String selectedValue;
  final List<String> items;

  DropdownStateData(this.items, {this.selectedValue = ""});

  DropdownStateData copyWith({String? selectedValue, List<String>? items}) {
    return DropdownStateData(
      items ?? this.items,
      selectedValue: selectedValue ?? this.selectedValue,
    );
  }
}

final dropdownStateProvider =
    StateNotifierProvider<DropdownState, DropdownStateData>((ref) {
  return DropdownState([]); // Initially empty list
});
