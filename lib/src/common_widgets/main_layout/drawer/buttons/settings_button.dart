import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

class MainDrawerSettingsButton extends StatelessWidget {
  const MainDrawerSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.settings),
        title: Text(S.of(context).settings),
        onTap: () {
          Navigator.of(context).pop();
          context.goNamed(AppRoute.settings.name);
        });
  }
}
