import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/widgets/form_frame.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/widgets/image_slider.dart';
import 'package:tablets/src/common/widgets/dialog_delete_confirmation.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_controller.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/features/customers/view/customer_form_fields.dart';

class CustomerForm extends ConsumerWidget {
  const CustomerForm({this.isEditMode = false, super.key});
  final bool isEditMode; // used by formController to decide whether to update or save in db

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(customerFormControllerProvider);
    final formDataNotifier = ref.read(customerFormDataProvider.notifier);
    final formImagesNotifier = ref.read(imagePickerProvider.notifier);
    ref.watch(imagePickerProvider);
    return FormFrame(
      formKey: formController.formKey,
      fields: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageSlider(imageUrls: formDataNotifier.data['imageUrls']),
          VerticalGap.l,
          const CustomerFormFields(),
        ],
      ),
      buttons: [
        IconButton(
          onPressed: () {
            if (!formController.validateData()) return;
            formController.submitData();
            final updateFormData = formDataNotifier.data;
            tempPrint(updateFormData);
            final imageUrls = formImagesNotifier.saveChanges();
            final customer = Customer.fromMap({...updateFormData, 'imageUrls': imageUrls});
            formController.saveItemToDb(context, customer, isEditMode);
          },
          icon: const SaveIcon(),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const CancelIcon(),
        ),
        Visibility(
          visible: isEditMode,
          child: IconButton(
              onPressed: () async {
                bool? confiramtion =
                    await showDeleteConfirmationDialog(context: context, message: formDataNotifier.data['name']);
                if (confiramtion != null) {
                  final updateFormData = formDataNotifier.data;
                  final imageUrls = formImagesNotifier.saveChanges();
                  final customer = Customer.fromMap({...updateFormData, 'imageUrls': imageUrls});
                  // ignore: use_build_context_synchronously
                  formController.deleteItemFromDb(context, customer);
                }
              },
              icon: const DeleteIcon()),
        )
      ],
      width: customerFormWidth,
      height: customerFormHeight,
    );
  }
}
