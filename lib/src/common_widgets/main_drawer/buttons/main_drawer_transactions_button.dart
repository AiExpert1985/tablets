import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

class MainDrawerTransactionsButton extends ConsumerWidget {
  const MainDrawerTransactionsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.settings),
      title: Text(S.of(context).transactions),
      onTap: () => context.pushNamed(AppRoute.transactions.name),
    );
  }
}
