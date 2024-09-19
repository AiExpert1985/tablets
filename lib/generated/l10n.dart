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

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
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

  /// `You should enter a valid number`
  String get input_validation_error_message_for_numbers {
    return Intl.message(
      'You should enter a valid number',
      name: 'input_validation_error_message_for_numbers',
      desc: '',
      args: [],
    );
  }

  /// `You should enter a valid name`
  String get input_validation_error_message_for_names {
    return Intl.message(
      'You should enter a valid name',
      name: 'input_validation_error_message_for_names',
      desc: '',
      args: [],
    );
  }

  /// `Error happened while login`
  String get error_login_to_db {
    return Intl.message(
      'Error happened while login',
      name: 'error_login_to_db',
      desc: '',
      args: [],
    );
  }

  /// `An error happened while adding a document to the database`
  String get error_adding_doc_to_db {
    return Intl.message(
      'An error happened while adding a document to the database',
      name: 'error_adding_doc_to_db',
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

  /// `Document was successfuly added to the database`
  String get success_adding_doc_to_db {
    return Intl.message(
      'Document was successfuly added to the database',
      name: 'success_adding_doc_to_db',
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
