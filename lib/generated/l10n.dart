// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signup {
    return Intl.message(
      'Sign up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Create a new account`
  String get create_new_account {
    return Intl.message(
      'Create a new account',
      name: 'create_new_account',
      desc: '',
      args: [],
    );
  }

  /// `I already have account`
  String get i_already_have_account {
    return Intl.message(
      'I already have account',
      name: 'i_already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Add image`
  String get add_image {
    return Intl.message(
      'Add image',
      name: 'add_image',
      desc: '',
      args: [],
    );
  }

  /// `Choose image`
  String get choose_image {
    return Intl.message(
      'Choose image',
      name: 'choose_image',
      desc: '',
      args: [],
    );
  }

  /// `Add a new user`
  String get add_new_user {
    return Intl.message(
      'Add a new user',
      name: 'add_new_user',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Save changes`
  String get save_changes {
    return Intl.message(
      'Save changes',
      name: 'save_changes',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get reports {
    return Intl.message(
      'Reports',
      name: 'reports',
      desc: '',
      args: [],
    );
  }

  /// `hi`
  String get greeting {
    return Intl.message(
      'hi',
      name: 'greeting',
      desc: '',
      args: [],
    );
  }

  /// `logout`
  String get logout {
    return Intl.message(
      'logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Privilage`
  String get user_privilage {
    return Intl.message(
      'Privilage',
      name: 'user_privilage',
      desc: '',
      args: [],
    );
  }

  /// `Page is not found`
  String get page_not_found {
    return Intl.message(
      'Page is not found',
      name: 'page_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Go back to home page`
  String get go_home_page {
    return Intl.message(
      'Go back to home page',
      name: 'go_home_page',
      desc: '',
      args: [],
    );
  }

  /// `Transactions`
  String get transactions {
    return Intl.message(
      'Transactions',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Salesmen`
  String get salesmen_movement {
    return Intl.message(
      'Salesmen',
      name: 'salesmen_movement',
      desc: '',
      args: [],
    );
  }

  /// `Pending transactions`
  String get pending_transactions {
    return Intl.message(
      'Pending transactions',
      name: 'pending_transactions',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Select category`
  String get category_selection {
    return Intl.message(
      'Select category',
      name: 'category_selection',
      desc: '',
      args: [],
    );
  }

  /// `Failure`
  String get failure {
    return Intl.message(
      'Failure',
      name: 'failure',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `info`
  String get info {
    return Intl.message(
      'info',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Tablets, where accounting started`
  String get slogan {
    return Intl.message(
      'Tablets, where accounting started',
      name: 'slogan',
      desc: '',
      args: [],
    );
  }

  /// `code`
  String get product_code {
    return Intl.message(
      'code',
      name: 'product_code',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get product_name {
    return Intl.message(
      'Name',
      name: 'product_name',
      desc: '',
      args: [],
    );
  }

  /// `Retail price`
  String get product_sell_retail_price {
    return Intl.message(
      'Retail price',
      name: 'product_sell_retail_price',
      desc: '',
      args: [],
    );
  }

  /// `Wholesale price`
  String get product_sell_whole_price {
    return Intl.message(
      'Wholesale price',
      name: 'product_sell_whole_price',
      desc: '',
      args: [],
    );
  }

  /// `Packaging type`
  String get product_package_type {
    return Intl.message(
      'Packaging type',
      name: 'product_package_type',
      desc: '',
      args: [],
    );
  }

  /// `Package weight`
  String get product_package_weight {
    return Intl.message(
      'Package weight',
      name: 'product_package_weight',
      desc: '',
      args: [],
    );
  }

  /// `Number of item in eacch package`
  String get product_num_items_inside_package {
    return Intl.message(
      'Number of item in eacch package',
      name: 'product_num_items_inside_package',
      desc: '',
      args: [],
    );
  }

  /// `Alert when available more than`
  String get product_alert_when_exceeds {
    return Intl.message(
      'Alert when available more than',
      name: 'product_alert_when_exceeds',
      desc: '',
      args: [],
    );
  }

  /// `Alert when available is less than`
  String get product_altert_when_less_than {
    return Intl.message(
      'Alert when available is less than',
      name: 'product_altert_when_less_than',
      desc: '',
      args: [],
    );
  }

  /// `Salesman commision`
  String get product_salesman_comission {
    return Intl.message(
      'Salesman commision',
      name: 'product_salesman_comission',
      desc: '',
      args: [],
    );
  }

  /// `Product photos`
  String get product_photos {
    return Intl.message(
      'Product photos',
      name: 'product_photos',
      desc: '',
      args: [],
    );
  }

  /// `Product category`
  String get product_category {
    return Intl.message(
      'Product category',
      name: 'product_category',
      desc: '',
      args: [],
    );
  }

  /// `Product subcategory`
  String get product_subcategory {
    return Intl.message(
      'Product subcategory',
      name: 'product_subcategory',
      desc: '',
      args: [],
    );
  }

  /// `Product initial quantity`
  String get product_initial_quantitiy {
    return Intl.message(
      'Product initial quantity',
      name: 'product_initial_quantitiy',
      desc: '',
      args: [],
    );
  }

  /// `Password should be at least 6 characters`
  String get input_validation_error_message_for_password {
    return Intl.message(
      'Password should be at least 6 characters',
      name: 'input_validation_error_message_for_password',
      desc: '',
      args: [],
    );
  }

  /// `Name should be at least 4 characters`
  String get input_validation_error_message_for_user_name {
    return Intl.message(
      'Name should be at least 4 characters',
      name: 'input_validation_error_message_for_user_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email adress`
  String get input_validation_error_message_for_email {
    return Intl.message(
      'Please enter a valid email adress',
      name: 'input_validation_error_message_for_email',
      desc: '',
      args: [],
    );
  }

  /// `You must select user privilage`
  String get input_validation_error_message_for_user_privilage {
    return Intl.message(
      'You must select user privilage',
      name: 'input_validation_error_message_for_user_privilage',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid word`
  String get input_validation_error_message_for_text {
    return Intl.message(
      'Enter a valid word',
      name: 'input_validation_error_message_for_text',
      desc: '',
      args: [],
    );
  }

  /// `Enter an integer number`
  String get input_validation_error_message_for_numbers {
    return Intl.message(
      'Enter an integer number',
      name: 'input_validation_error_message_for_numbers',
      desc: '',
      args: [],
    );
  }

  /// `Select a date`
  String get input_validation_error_message_for_date {
    return Intl.message(
      'Select a date',
      name: 'input_validation_error_message_for_date',
      desc: '',
      args: [],
    );
  }

  /// `An error happend while importing images`
  String get error_importing_image {
    return Intl.message(
      'An error happend while importing images',
      name: 'error_importing_image',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Add a new Category`
  String get add_new_category {
    return Intl.message(
      'Add a new Category',
      name: 'add_new_category',
      desc: '',
      args: [],
    );
  }

  /// `Update category`
  String get update_category {
    return Intl.message(
      'Update category',
      name: 'update_category',
      desc: '',
      args: [],
    );
  }

  /// `There is no contents`
  String get screen_is_empty {
    return Intl.message(
      'There is no contents',
      name: 'screen_is_empty',
      desc: '',
      args: [],
    );
  }

  /// `Not found in database`
  String get search_not_found_in_db {
    return Intl.message(
      'Not found in database',
      name: 'search_not_found_in_db',
      desc: '',
      args: [],
    );
  }

  /// `Error happened while login`
  String get db_error_login {
    return Intl.message(
      'Error happened while login',
      name: 'db_error_login',
      desc: '',
      args: [],
    );
  }

  /// `An error happened while adding to the database`
  String get db_error_adding_doc {
    return Intl.message(
      'An error happened while adding to the database',
      name: 'db_error_adding_doc',
      desc: '',
      args: [],
    );
  }

  /// `An error happened while updating the database`
  String get db_error_updating_doc {
    return Intl.message(
      'An error happened while updating the database',
      name: 'db_error_updating_doc',
      desc: '',
      args: [],
    );
  }

  /// `Document was added successfully`
  String get db_success_adding_doc {
    return Intl.message(
      'Document was added successfully',
      name: 'db_success_adding_doc',
      desc: '',
      args: [],
    );
  }

  /// `Document was saved successfully`
  String get db_success_saving_doc {
    return Intl.message(
      'Document was saved successfully',
      name: 'db_success_saving_doc',
      desc: '',
      args: [],
    );
  }

  /// `An error happened while saving from db`
  String get db_error_saving_doc {
    return Intl.message(
      'An error happened while saving from db',
      name: 'db_error_saving_doc',
      desc: '',
      args: [],
    );
  }

  /// `Document was updated successfully `
  String get db_success_updaging_doc {
    return Intl.message(
      'Document was updated successfully ',
      name: 'db_success_updaging_doc',
      desc: '',
      args: [],
    );
  }

  /// `Document was deleted successfully`
  String get db_success_deleting_doc {
    return Intl.message(
      'Document was deleted successfully',
      name: 'db_success_deleting_doc',
      desc: '',
      args: [],
    );
  }

  /// `An error happened while deleting from db`
  String get db_error_deleting_doc {
    return Intl.message(
      'An error happened while deleting from db',
      name: 'db_error_deleting_doc',
      desc: '',
      args: [],
    );
  }

  /// `An error happened while downloading files from database`
  String get db_error_downloading_files {
    return Intl.message(
      'An error happened while downloading files from database',
      name: 'db_error_downloading_files',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete`
  String get alert_before_delete {
    return Intl.message(
      'Do you want to delete',
      name: 'alert_before_delete',
      desc: '',
      args: [],
    );
  }

  /// `Transaction type`
  String get transaction_type {
    return Intl.message(
      'Transaction type',
      name: 'transaction_type',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get transaction_name {
    return Intl.message(
      'Name',
      name: 'transaction_name',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get transaction_date {
    return Intl.message(
      'Date',
      name: 'transaction_date',
      desc: '',
      args: [],
    );
  }

  /// `Number`
  String get transaction_number {
    return Intl.message(
      'Number',
      name: 'transaction_number',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get transaction_amount {
    return Intl.message(
      'Amount',
      name: 'transaction_amount',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get transaction_currency {
    return Intl.message(
      'Currency',
      name: 'transaction_currency',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get transaction_notes {
    return Intl.message(
      'Notes',
      name: 'transaction_notes',
      desc: '',
      args: [],
    );
  }

  /// `Customer Name`
  String get transaction_customer_invoice_name {
    return Intl.message(
      'Customer Name',
      name: 'transaction_customer_invoice_name',
      desc: '',
      args: [],
    );
  }

  /// `Payment type`
  String get transaction_payment_type {
    return Intl.message(
      'Payment type',
      name: 'transaction_payment_type',
      desc: '',
      args: [],
    );
  }

  /// `Salesman`
  String get transaction_salesman {
    return Intl.message(
      'Salesman',
      name: 'transaction_salesman',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get transaction_discount {
    return Intl.message(
      'Discount',
      name: 'transaction_discount',
      desc: '',
      args: [],
    );
  }

  /// `Item`
  String get transaction_item_name {
    return Intl.message(
      'Item',
      name: 'transaction_item_name',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get transaction_item_quantity {
    return Intl.message(
      'Quantity',
      name: 'transaction_item_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get transaction_item_price {
    return Intl.message(
      'Price',
      name: 'transaction_item_price',
      desc: '',
      args: [],
    );
  }

  /// `Gift`
  String get transaction_item_gift {
    return Intl.message(
      'Gift',
      name: 'transaction_item_gift',
      desc: '',
      args: [],
    );
  }

  /// `Total price`
  String get transaction_item_total_price {
    return Intl.message(
      'Total price',
      name: 'transaction_item_total_price',
      desc: '',
      args: [],
    );
  }

  /// `Select a date`
  String get date_picker_hint {
    return Intl.message(
      'Select a date',
      name: 'date_picker_hint',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get transaction_payment_cash {
    return Intl.message(
      'Cash',
      name: 'transaction_payment_cash',
      desc: '',
      args: [],
    );
  }

  /// `Credit`
  String get transaction_payment_credit {
    return Intl.message(
      'Credit',
      name: 'transaction_payment_credit',
      desc: '',
      args: [],
    );
  }

  /// `IQ Dinar`
  String get transaction_payment_Dinar {
    return Intl.message(
      'IQ Dinar',
      name: 'transaction_payment_Dinar',
      desc: '',
      args: [],
    );
  }

  /// `US Dollar`
  String get transaction_payment_Dollar {
    return Intl.message(
      'US Dollar',
      name: 'transaction_payment_Dollar',
      desc: '',
      args: [],
    );
  }

  /// `Expenditures`
  String get transaction_type_expenditures {
    return Intl.message(
      'Expenditures',
      name: 'transaction_type_expenditures',
      desc: '',
      args: [],
    );
  }

  /// `Gifts`
  String get transaction_type_gifts {
    return Intl.message(
      'Gifts',
      name: 'transaction_type_gifts',
      desc: '',
      args: [],
    );
  }

  /// `Customer Receipt`
  String get transaction_type_customer_receipt {
    return Intl.message(
      'Customer Receipt',
      name: 'transaction_type_customer_receipt',
      desc: '',
      args: [],
    );
  }

  /// `Vendor Receipt`
  String get transaction_type_vendor_receipt {
    return Intl.message(
      'Vendor Receipt',
      name: 'transaction_type_vendor_receipt',
      desc: '',
      args: [],
    );
  }

  /// `Vender Return`
  String get transaction_type_vender_return {
    return Intl.message(
      'Vender Return',
      name: 'transaction_type_vender_return',
      desc: '',
      args: [],
    );
  }

  /// `Customer Return`
  String get transaction_type_customer_return {
    return Intl.message(
      'Customer Return',
      name: 'transaction_type_customer_return',
      desc: '',
      args: [],
    );
  }

  /// `Vender Invoice`
  String get transaction_type_vender_invoice {
    return Intl.message(
      'Vender Invoice',
      name: 'transaction_type_vender_invoice',
      desc: '',
      args: [],
    );
  }

  /// `Customer Invoice`
  String get transaction_type_customer_invoice {
    return Intl.message(
      'Customer Invoice',
      name: 'transaction_type_customer_invoice',
      desc: '',
      args: [],
    );
  }

  /// `Damaged Items`
  String get transaction_type_damaged_items {
    return Intl.message(
      'Damaged Items',
      name: 'transaction_type_damaged_items',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get salesman_name {
    return Intl.message(
      'Name',
      name: 'salesman_name',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get category_name {
    return Intl.message(
      'Name',
      name: 'category_name',
      desc: '',
      args: [],
    );
  }

  /// `Salesmen`
  String get salesmen {
    return Intl.message(
      'Salesmen',
      name: 'salesmen',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get customer_name {
    return Intl.message(
      'Name',
      name: 'customer_name',
      desc: '',
      args: [],
    );
  }

  /// `Customers`
  String get customers {
    return Intl.message(
      'Customers',
      name: 'customers',
      desc: '',
      args: [],
    );
  }

  /// `Salesman selection`
  String get salesman_selection {
    return Intl.message(
      'Salesman selection',
      name: 'salesman_selection',
      desc: '',
      args: [],
    );
  }

  /// `Customer`
  String get customer {
    return Intl.message(
      'Customer',
      name: 'customer',
      desc: '',
      args: [],
    );
  }

  /// `#`
  String get item_sequence {
    return Intl.message(
      '#',
      name: 'item_sequence',
      desc: '',
      args: [],
    );
  }

  /// `Item name`
  String get item_name {
    return Intl.message(
      'Item name',
      name: 'item_name',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get item_price {
    return Intl.message(
      'Price',
      name: 'item_price',
      desc: '',
      args: [],
    );
  }

  /// `Sold Qtty.`
  String get item_sold_quantity {
    return Intl.message(
      'Sold Qtty.',
      name: 'item_sold_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get item_total_price {
    return Intl.message(
      'Total',
      name: 'item_total_price',
      desc: '',
      args: [],
    );
  }

  /// `Gifts Qtty.`
  String get item_gifts_quantity {
    return Intl.message(
      'Gifts Qtty.',
      name: 'item_gifts_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Total price`
  String get invoice_total_price {
    return Intl.message(
      'Total price',
      name: 'invoice_total_price',
      desc: '',
      args: [],
    );
  }

  /// `Total weight`
  String get invoice_total_weight {
    return Intl.message(
      'Total weight',
      name: 'invoice_total_weight',
      desc: '',
      args: [],
    );
  }

  /// `Total as text`
  String get transaction_total_amount_as_text {
    return Intl.message(
      'Total as text',
      name: 'transaction_total_amount_as_text',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get approve {
    return Intl.message(
      'Yes',
      name: 'approve',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Number`
  String get number {
    return Intl.message(
      'Number',
      name: 'number',
      desc: '',
      args: [],
    );
  }

  /// `Include payment as text`
  String get include_total_as_text {
    return Intl.message(
      'Include payment as text',
      name: 'include_total_as_text',
      desc: '',
      args: [],
    );
  }

  /// `yes`
  String get yes {
    return Intl.message(
      'yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Vendors`
  String get vendors {
    return Intl.message(
      'Vendors',
      name: 'vendors',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
