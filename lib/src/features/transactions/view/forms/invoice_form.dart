import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/customer_utils.dart';
import 'package:tablets/src/common/providers/background_color.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/common/values/settings.dart' as settings;
import 'package:tablets/src/common/values/settings.dart';
import 'package:tablets/src/common/widgets/form_fields/date_picker.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_repository_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/common/widgets/form_title.dart';
import 'package:tablets/src/features/transactions/view/forms/item_list.dart';
import 'package:tablets/src/common/values/transactions_common_values.dart';
import 'package:tablets/src/features/vendors/repository/vendor_repository_provider.dart';

// I used ConsumerStatefulWidget because I find no other way to define customer global variable
// which I used for coloring the background of the invoice when debt exceeds limits
// because ConsumerWidget doen't allow declaring non final variables like customer
class InvoiceForm extends ConsumerStatefulWidget {
  const InvoiceForm(this.title, this.transactionType,
      {this.allTransactions, this.isVendor = false, this.hideGifts = true, super.key});

  final String title;
  final bool hideGifts;
  final bool isVendor;
  final List<Map<String, dynamic>>? allTransactions;
  final String transactionType;

  @override
  ConsumerState<InvoiceForm> createState() => _InvoiceFormState();
}

class _InvoiceFormState extends ConsumerState<InvoiceForm> {
  // customer is only used for calculation of exceeded debt
  // which is used for changing background color
  Customer? customer;

  // returns a color based on customer current debt
  Color customerExceedsDebtLimit(Customer selectedCustomer, ItemFormData formDataNotifier) {
    final customerTransactions =
        getCustomerTransactions(widget.allTransactions!, selectedCustomer.dbRef);
    final totalDebt = getTotalDebt(customerTransactions, selectedCustomer);
    final creditLimit = selectedCustomer.creditLimit;
    if (totalDebt >= creditLimit) {}
    final totalAfterCurrentTransaction = totalDebt + formDataNotifier.getProperty(totalAmountKey);
    final openInvoices = getOpenInvoices(customerTransactions, totalDebt);
    final dueInvoices = getDueInvoices(openInvoices, selectedCustomer.paymentDurationLimit);
    if (totalAfterCurrentTransaction > creditLimit || dueInvoices.isNotEmpty) {
      return const Color.fromARGB(255, 229, 177, 177);
    }
    if (totalAfterCurrentTransaction > creditLimit * debtAmountWarning) {
      return const Color.fromARGB(255, 243, 237, 187);
    }
    return Colors.white;
  }

  Color customerExceedsTimeLimit(Map<String, dynamic> item, ItemFormData formDataNotifier) {
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final textEditingNotifier = ref.read(textFieldsControllerProvider.notifier);
    final salesmanRepository = ref.read(salesmanRepositoryProvider);
    final customerRepository = ref.read(customerRepositoryProvider);
    final vendorRepository = ref.read(vendorRepositoryProvider);
    final productRepository = ref.read(productRepositoryProvider);
    final counterPartyRepository = widget.isVendor ? vendorRepository : customerRepository;
    final backgroundColorNotifier = ref.read(backgroundColorProvider.notifier);
    ref.watch(transactionFormDataProvider);

    return SingleChildScrollView(
      child: Container(
        // color: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildFormTitle(widget.title),
            VerticalGap.xl,
            _buildFirstRow(context, formDataNotifier, counterPartyRepository, salesmanRepository,
                widget.isVendor, backgroundColorNotifier),
            VerticalGap.m,
            _buildSecondRow(context, formDataNotifier, textEditingNotifier),
            VerticalGap.m,
            _buildThirdRow(context, formDataNotifier),
            VerticalGap.m,
            _buildForthRow(context, formDataNotifier),
            VerticalGap.m,
            _buildFifthRow(context, formDataNotifier),
            VerticalGap.m,
            buildItemList(context, formDataNotifier, textEditingNotifier, productRepository,
                widget.hideGifts, false),
            VerticalGap.xxl,
            _buildTotalsRow(
                context, formDataNotifier, textEditingNotifier, backgroundColorNotifier),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstRow(
      BuildContext context,
      ItemFormData formDataNotifier,
      DbRepository repository,
      DbRepository salesmanRepository,
      bool isVendor,
      StateController<Color> backgroundColorNotifier) {
    return Row(
      children: [
        DropDownWithSearchFormField(
          label: isVendor ? S.of(context).vendor : S.of(context).customer,
          initialValue: formDataNotifier.getProperty(nameKey),
          dbRepository: repository,
          onChangedFn: (item) {
            // update customer field & related fields
            final properties = {
              nameKey: item['name'],
              nameDbRefKey: item['dbRef'],
              salesmanKey: item['salesman'],
              salesmanDbRefKey: item['salesmanDbRef']
            };
            formDataNotifier.updateProperties(properties);
            // check wether customer exceeded the debt or time limits
            // below applies only for customer invoices not any other transaction
            if (widget.transactionType != TransactionType.customerInvoice.name ||
                widget.allTransactions == null) {
              return;
            }
            customer = Customer.fromMap(item);
            final invoiceColor = customerExceedsDebtLimit(customer!, formDataNotifier);
            backgroundColorNotifier.state = invoiceColor;
          },
        ),
        if (!isVendor) HorizontalGap.l,
        if (!isVendor)
          DropDownWithSearchFormField(
            label: S.of(context).transaction_salesman,
            initialValue: formDataNotifier.getProperty(salesmanKey),
            dbRepository: salesmanRepository,
            onChangedFn: (item) {
              formDataNotifier
                  .updateProperties({salesmanKey: item['name'], salesmanDbRefKey: item['dbRef']});
            },
          ),
      ],
    );
  }

  Widget _buildSecondRow(BuildContext context, ItemFormData formDataNotifier,
      TextControllerNotifier textEditingNotifier) {
    return Row(
      children: [
        DropDownListFormField(
          initialValue: formDataNotifier.getProperty(currencyKey),
          itemList: [
            S.of(context).transaction_payment_Dinar,
            S.of(context).transaction_payment_Dollar,
          ],
          label: S.of(context).transaction_currency,
          name: currencyKey,
          onChangedFn: (value) {
            formDataNotifier.updateProperties({currencyKey: value});
          },
        ),
        HorizontalGap.l,
        FormInputField(
          initialValue: formDataNotifier.getProperty(discountKey),
          name: discountKey,
          dataType: constants.FieldDataType.num,
          label: S.of(context).transaction_discount,
          onChangedFn: (value) {
            formDataNotifier.updateProperties({discountKey: value});
            final subTotalAmount = formDataNotifier.getProperty(subTotalAmountKey);
            final totalAmount = subTotalAmount - value;
            final updatedProperties = {totalAmountKey: totalAmount};
            formDataNotifier.updateProperties(updatedProperties);
            textEditingNotifier.updateControllers(updatedProperties);
          },
        ),
      ],
    );
  }

  Widget _buildThirdRow(BuildContext context, ItemFormData formDataNotifier) {
    return Row(
      children: [
        FormInputField(
          dataType: constants.FieldDataType.num,
          name: numberKey,
          label: S.of(context).transaction_number,
          initialValue: formDataNotifier.getProperty(numberKey),
          onChangedFn: (value) {
            formDataNotifier.updateProperties({numberKey: value});
          },
        ),
        HorizontalGap.l,
        DropDownListFormField(
          initialValue: formDataNotifier.getProperty(paymentTypeKey),
          itemList: [
            S.of(context).transaction_payment_cash,
            S.of(context).transaction_payment_credit,
          ],
          label: S.of(context).transaction_payment_type,
          name: paymentTypeKey,
          onChangedFn: (value) {
            formDataNotifier.updateProperties({paymentTypeKey: value});
          },
        ),
        HorizontalGap.l,
        FormDatePickerField(
          initialValue: formDataNotifier.getProperty(dateKey) is Timestamp
              ? formDataNotifier.getProperty(dateKey).toDate()
              : formDataNotifier.getProperty(dateKey),
          name: dateKey,
          label: S.of(context).transaction_date,
          onChangedFn: (date) {
            formDataNotifier.updateProperties({dateKey: Timestamp.fromDate(date!)});
          },
        ),
      ],
    );
  }

  Widget _buildForthRow(BuildContext context, ItemFormData formDataNotifier) {
    return Row(
      children: [
        FormInputField(
          isRequired: false,
          dataType: constants.FieldDataType.string,
          name: notesKey,
          label: S.of(context).transaction_notes,
          initialValue: formDataNotifier.getProperty(notesKey),
          onChangedFn: (value) {
            formDataNotifier.updateProperties({notesKey: value});
          },
        ),
      ],
    );
  }

  Widget _buildFifthRow(BuildContext context, ItemFormData formDataNotifier) {
    return Visibility(
      visible: settings.writeTotalAmountAsText,
      child: Row(
        children: [
          FormInputField(
            isRequired: false,
            dataType: constants.FieldDataType.string,
            name: totalAsTextKey,
            label: S.of(context).transaction_total_amount_as_text,
            initialValue: formDataNotifier.getProperty(totalAsTextKey),
            onChangedFn: (value) {
              formDataNotifier.updateProperties({totalAsTextKey: value});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsRow(BuildContext context, ItemFormData formDataNotifier,
      TextControllerNotifier textEditingNotifier, StateController<Color> backgroundColorNotifier) {
    return SizedBox(
        width: customerInvoiceFormWidth * 0.6,
        child: Row(
          children: [
            FormInputField(
              controller: textEditingNotifier.getController(totalAmountKey),
              isReadOnly: true,
              dataType: constants.FieldDataType.num,
              label: S.of(context).invoice_total_price,
              name: totalAmountKey,
              initialValue: formDataNotifier.getProperty(totalAmountKey),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({totalAmountKey: value});
                // check wether customer exceeded the debt or time limits
                // below applies only for customer invoices not any other transaction
                if (customer == null ||
                    widget.allTransactions == null ||
                    widget.transactionType != TransactionType.customerInvoice.name) {
                  return;
                }
                final invoiceColor = customerExceedsDebtLimit(customer!, formDataNotifier);
                backgroundColorNotifier.state = invoiceColor;
              },
            ),
            HorizontalGap.xxl,
            FormInputField(
              controller: textEditingNotifier.getController(totalWeightKey),
              isReadOnly: true,
              dataType: constants.FieldDataType.num,
              label: S.of(context).invoice_total_weight,
              name: totalWeightKey,
              initialValue: formDataNotifier.getProperty(totalWeightKey),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({totalWeightKey: value});
              },
            ),
          ],
        ));
  }
}
