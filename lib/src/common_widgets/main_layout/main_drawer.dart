import 'package:flutter/material.dart';
import 'package:tablets/src/common_widgets/main_layout/main_drawer_buttons.dart';
import 'package:tablets/src/common_widgets/main_layout/main_drawer_header.dart';
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
                  constants.DrawerGap.vertical,
                  const MainDrawerCategoriesButton(),
                  constants.PushWidgets.toEnd,
                  const MainDrawerPendingBillsButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
