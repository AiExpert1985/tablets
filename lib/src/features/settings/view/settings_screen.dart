import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/features/settings/repository/settings_repository_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesmantStream = ref.watch(settingsStreamProvider);
    return AsyncValueWidget<List<Map<String, dynamic>>>(
      value: salesmantStream,
      data: (categories) => GridView.builder(
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (ctx, index) {
          final salesman = Salesman.fromMap(categories[index]);
          return InkWell(
            hoverColor: const Color.fromARGB(255, 173, 170, 170),
            onTap: () => showEditSalesmanForm(ctx, ref, salesman),
            child: TitledImage(
              imageUrl: salesman.coverImageUrl,
              title: salesman.name,
            ),
          );
        },
      ),
    );
  }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return AppScreenFrame(
//       screenBody: Center(
//         child: Column(
//           children: [
//             Row(children: [
//               Text(S.of(context).transaction_payment_type),
//               HorizontalGap.l,
//               InkWell(
//                 child: const Text('sdfsdfs'),
//                 onTap: () {},
//               )
//             ]),
//             Row(children: [Text(S.of(context).transaction_currency), HorizontalGap.l, const Text('sdfsdfs')]),
//             Row(children: [Text(S.of(context).include_total_as_text), HorizontalGap.l, const Text('sdfsdfs')]),
//           ],
//         ),
//       ),
//     );
//   }
}
