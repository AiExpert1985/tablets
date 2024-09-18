// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class DropdownState extends StateNotifier<String> {
//   DropdownState(this.initialValue) : super(initialValue);

//   final String initialValue;

//   void updateSelectedValue(String newValue) {
//     state = newValue;
//   }
// }

// final dropdownStateProvider =
//     StateNotifierProvider<DropdownState, String>((ref) {
//   return DropdownState('');
// });

// class MyForm extends ConsumerStatefulWidget {
//   const MyForm({super.key});

//   @override
//   ConsumerState<MyForm> createState() => _MyFormState();
// }

// class _MyFormState extends State<MyForm> {
//   final _formKey = GlobalKey<FormState>();
//   final dropdownStateProvider = ref.watch(dropdownStateProvider);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//             stream: FirebaseFirestore.instance
//                 .collection('your_collection')
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 return Text('Error: ${snapshot.error}');
//               }

//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const CircularProgressIndicator();
//               }

//               final items = snapshot.data!.docs.map((doc) {
//                 return doc[
//                     'item_name']; // Replace 'item_name' with your actual field name
//               }).toList();

//               return DropdownButtonFormField<String>(
//                 value: dropdownStateProvider.selectedValue,
//                 onChanged: (value) {
//                   ref
//                       .read(dropdownStateProvider.notifier)
//                       .updateSelectedValue(value!);
//                 },
//                 items: items.map((item) {
//                   return DropdownMenuItem<String>(
//                     value: item,
//                     child: Text(item),
//                   );
//                 }).toList(),
//                 decoration: const InputDecoration(
//                   labelText: 'Select an item',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please select an item';
//                   }
//                   return null;
//                 },
//               );
//             },
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState!.validate()) {
//                 // Form is valid, do something with selectedValue
//                 print('Selected value: ${dropdownStateProvider.selectedValue}');
//               }
//             },
//             child: const Text('Submit'),
//           ),
//         ],
//       ),
//     );
//   }
// }
