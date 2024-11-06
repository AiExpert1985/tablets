// ignore_for_file: public_member_api_docs, sort_constructors_first

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

  @override
  String toString() =>
      'Settings(paymentType: $paymentType, writeTotalAmountAsText: $writeTotalAmountAsText, currency: $currency)';
}
