import 'package:flutter/material.dart';
// import 'package:sidebarx/sidebarx.dart';
import 'package:tablets/src/common_widgets/main_layout/drawer/buttons/main_drawer_salesmen_gps_button.dart';
import 'package:tablets/src/common_widgets/main_layout/drawer/buttons/main_drawer_settings_button.dart';
import 'package:tablets/src/common_widgets/main_layout/drawer/header/main_drawer_header.dart';
import 'package:tablets/src/common_widgets/main_layout/drawer/buttons/main_drawer_products_button.dart';
import 'package:tablets/src/common_widgets/main_layout/drawer/buttons/main_drawer_transactions_button.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.2,
      child: const Column(
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

  // @override
  // Widget build(BuildContext context) {
  //   return SidebarX(
  //     controller: SidebarXController(selectedIndex: 0, extended: true),
  //     items: const [
  //       SidebarXItem(icon: Icons.home, label: 'Home'),
  //       SidebarXItem(icon: Icons.search, label: 'Search'),
  //     ],
  //   );
  // }
}
