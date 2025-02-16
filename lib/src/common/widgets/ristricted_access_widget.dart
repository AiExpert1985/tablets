import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/providers/user_info_provider.dart';

class RistrictedAccessWidget extends ConsumerWidget {
  final List<String> allowedPrivilages;
  final Widget child;

  const RistrictedAccessWidget({
    super.key,
    required this.allowedPrivilages,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    tempPrint(ref.read(userInfoProvider)?.privilage);
    if (!ref.read(userInfoProvider.notifier).hasPermission(allowedPrivilages)) {
      return Container();
    }

    return child;
  }
}
