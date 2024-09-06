import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

class MainDrawerProductsButton extends ConsumerWidget {
  const MainDrawerProductsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.search),
      title: Text(S.of(context).products),
      onTap: () => context.pushNamed(AppRoute.products.name),
    );
  }
}
