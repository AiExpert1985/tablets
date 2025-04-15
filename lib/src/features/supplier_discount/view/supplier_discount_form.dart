import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/common/widgets/custome_appbar_for_back_return.dart';
import 'package:tablets/src/common/widgets/form_frame.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/widgets/form_title.dart';
import 'package:tablets/src/features/regions/view/region_form_fields.dart';
import 'package:tablets/src/features/supplier_discount/model/supplier_discount.dart';
import 'package:tablets/src/features/supplier_discount/repository/supplier_discount_repository_provider.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

class SupplierDiscountForm extends ConsumerWidget {
  const SupplierDiscountForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: buildArabicAppBar(context, () async {
        // back to customers screen
        Navigator.pop(context);
      }, () async {
        // back to home screen
        Navigator.pop(context);
        context.goNamed(AppRoute.home.name);
      }),
      // body: const Text('hi')
      body: FormFrame(
        title: buildFormTitle(S.of(context).region),
        fields: Container(
          padding: const EdgeInsets.all(0),
          width: 800,
          height: 400,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              RegionFormFields(),
            ],
          ),
        ),
        buttons: [
          IconButton(
            onPressed: () => _onSavePress(context, ref),
            icon: const SaveIcon(),
          ),
          IconButton(
            onPressed: () => _onDeletePressed(context),
            icon: const DeleteIcon(),
          ),
        ],
        width: regionFormWidth,
        height: regionFormHeight,
      ),
    );
  }

  void _onSavePress(BuildContext context, WidgetRef ref) {
    final discountRep = ref.read(supplierDiscountRepositoryProvider);
    final discount = SupplierDiscount(
        dbRef: 'werwerwer',
        name: 'malksdfsdf',
        supplierDbRef: 'tey456456',
        supplierName: 'rhgrey45',
        productDbRef: 'erhry45645',
        productName: 'rtyrtyery',
        date: DateTime.now(),
        discountAmount: 1111,
        newPrice: 111111,
        quantity: 10);
    discountRep.addItem(discount);
    Navigator.pop(context);
  }

  void _onDeletePressed(BuildContext context) {
    Navigator.pop(context);
  }
}
