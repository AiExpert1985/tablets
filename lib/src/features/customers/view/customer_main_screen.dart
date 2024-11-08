import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/features/customers/view/customer_floating_buttons.dart';
import 'package:tablets/src/features/customers/view/customer_list.dart';

class CustomerScreen extends ConsumerWidget {
  const CustomerScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScreenFrame(
      screenBody: Stack(
        children: [
          buildCustomerList(context, ref),
          const Positioned(
            bottom: 0,
            left: 0,
            child: CustomerFloatingButtons(),
          )
        ],
      ),
    );
  }
}
