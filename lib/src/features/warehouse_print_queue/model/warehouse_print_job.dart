import 'package:cloud_firestore/cloud_firestore.dart';

class WarehousePrintJob {
  WarehousePrintJob({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.clientName,
    required this.invoiceDate,
    required this.itemCount,
    required this.totalPrice,
    required this.storagePath,
    required this.status,
    required this.createdAt,
    required this.createdById,
    required this.createdByName,
    required this.version,
    this.printedAt,
    this.printedById,
    this.printedByName,
  });

  final String invoiceId;
  final String invoiceNumber;
  final String clientName;
  final DateTime invoiceDate;
  final int itemCount;
  final double totalPrice;
  final String storagePath;
  final String status;
  final DateTime createdAt;
  final String createdById;
  final String createdByName;
  final int version;
  final DateTime? printedAt;
  final String? printedById;
  final String? printedByName;

  static const String pendingStatus = 'pending';
  static const String printedStatus = 'printed';

  WarehousePrintJob copyWith({
    String? status,
    DateTime? printedAt,
    String? printedById,
    String? printedByName,
    int? version,
    DateTime? createdAt,
    String? createdById,
    String? createdByName,
  }) {
    return WarehousePrintJob(
      invoiceId: invoiceId,
      invoiceNumber: invoiceNumber,
      clientName: clientName,
      invoiceDate: invoiceDate,
      itemCount: itemCount,
      totalPrice: totalPrice,
      storagePath: storagePath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      version: version ?? this.version,
      printedAt: printedAt ?? this.printedAt,
      printedById: printedById ?? this.printedById,
      printedByName: printedByName ?? this.printedByName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
      'invoiceNumber': invoiceNumber,
      'clientName': clientName,
      'invoiceDate': Timestamp.fromDate(invoiceDate),
      'itemCount': itemCount,
      'totalPrice': totalPrice,
      'storagePath': storagePath,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdById': createdById,
      'createdByName': createdByName,
      'version': version,
      'printedAt': printedAt == null ? null : Timestamp.fromDate(printedAt!),
      'printedById': printedById,
      'printedByName': printedByName,
    };
  }

  factory WarehousePrintJob.fromMap(Map<String, dynamic> map) {
    return WarehousePrintJob(
      invoiceId: map['invoiceId'] as String,
      invoiceNumber: map['invoiceNumber']?.toString() ?? '',
      clientName: map['clientName'] as String,
      invoiceDate: _timestampToDate(map['invoiceDate']),
      itemCount: (map['itemCount'] as num?)?.toInt() ?? 0,
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0,
      storagePath: map['storagePath'] as String,
      status: map['status'] as String,
      createdAt: _timestampToDate(map['createdAt']),
      createdById: map['createdById'] as String? ?? '',
      createdByName: map['createdByName'] as String? ?? '',
      version: (map['version'] as num?)?.toInt() ?? 1,
      printedAt: map['printedAt'] == null ? null : _timestampToDate(map['printedAt']),
      printedById: map['printedById'] as String?,
      printedByName: map['printedByName'] as String?,
    );
  }

  static DateTime _timestampToDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    throw ArgumentError('Unsupported date value: $value');
  }
}
