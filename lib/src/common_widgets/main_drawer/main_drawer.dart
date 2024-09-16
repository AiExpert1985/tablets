import 'package:flutter/material.dart';
import 'package:tablets/src/common_widgets/main_drawer/buttons/main_drawer_salesmen_gps_button.dart';
import 'package:tablets/src/common_widgets/main_drawer/buttons/main_drawer_settings_button.dart';
import 'package:tablets/src/common_widgets/main_drawer/header/main_drawer_header.dart';
import 'package:tablets/src/common_widgets/main_drawer/buttons/main_drawer_products_button.dart';
import 'package:tablets/src/common_widgets/main_drawer/buttons/main_drawer_transactions_button.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Column(
        children: [
          MainDrawerHeader(),
          SizedBox(height: 15),
          MainDrawerProductsButton(),
          SizedBox(height: 10),
          MainDrawerTransactionsButton(),
          SizedBox(height: 10),
          MainDrawerSalesmenMovementButton(),
          SizedBox(height: 10),
          MainDrawerSettingsButton(),
        ],
      ),
    );
  }
}
