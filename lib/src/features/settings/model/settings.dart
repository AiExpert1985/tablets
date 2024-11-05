// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum PaymentType { cash, credit }

enum Currency { dinar, dollar }

class Settings {
  Settings(
    this.paymentType,
    this.writeTotalAmountAsText,
    this.currency,
  );
  final String paymentType;
  final bool writeTotalAmountAsText;
  final String currency;

  Settings copyWith({
    String? paymentType,
    bool? writeTotalAmountAsText,
    String? currency,
  }) {
    return Settings(
      paymentType ?? this.paymentType,
      writeTotalAmountAsText ?? this.writeTotalAmountAsText,
      currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paymentType': paymentType,
      'writeTotalAmountAsText': writeTotalAmountAsText,
      'currency': currency,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      map['paymentType'] as String,
      map['writeTotalAmountAsText'] as bool,
      map['currency'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Settings.fromJson(String source) => Settings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Settings(paymentType: $paymentType, writeTotalAmountAsText: $writeTotalAmountAsText, currency: $currency)';

  @override
  bool operator ==(covariant Settings other) {
    if (identical(this, other)) return true;

    return other.paymentType == paymentType &&
        other.writeTotalAmountAsText == writeTotalAmountAsText &&
        other.currency == currency;
  }

  @override
  int get hashCode => paymentType.hashCode ^ writeTotalAmountAsText.hashCode ^ currency.hashCode;
}
