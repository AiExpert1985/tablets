import 'package:flutter/material.dart';
import 'package:tablets/src/common_widgets/main_layout/app_bar/logout_button.dart';
// import 'package:sidebarx/sidebarx.dart';
import 'package:tablets/src/common_widgets/main_layout/drawer/buttons/salesmen_gps_button.dart';
import 'package:tablets/src/common_widgets/main_layout/drawer/buttons/settings_button.dart';
import 'package:tablets/src/common_widgets/main_layout/drawer/header/main_drawer_header.dart';
import 'package:tablets/src/common_widgets/main_layout/drawer/buttons/products_button.dart';
import 'package:tablets/src/common_widgets/main_layout/drawer/buttons/transactions_button.dart';
import 'package:tablets/src/constants/constants.dart' as constants;

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.17,
      child: Column(
        children: [
          const MainDrawerHeader(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.01,
                horizontal: MediaQuery.of(context).size.width * 0.01,
              ),
              child: Column(
                children: [
                  const MainDrawerProductsButton(),
                  constants.DrawerGap.vertical,
                  const MainDrawerTransactionsButton(),
                  constants.DrawerGap.vertical,
                  const MainDrawerSalesmenMovementButton(),
                  constants.DrawerGap.vertical,
                  const MainDrawerSettingsButton(),
                  constants.PushWidgets.toEnd,
                  const LogoutButton(),
                ],
              ),
            ),
          ),
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
