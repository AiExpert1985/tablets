import 'package:cloud_firestore/cloud_firestore.dart';

class WarehousePrintJob {
  const WarehousePrintJob({
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
    this.printedAt,
    this.printedById,
    this.printedByName,
    this.version = 0,
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
  final DateTime? printedAt;
  final String? printedById;
  final String? printedByName;
  final int version;

  static const pendingStatus = 'pending';
  static const printedStatus = 'printed';

  WarehousePrintJob copyWith({
    String? status,
    DateTime? printedAt,
    String? printedById,
    String? printedByName,
    int? version,
    DateTime? createdAt,
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
      createdById: createdById,
      createdByName: createdByName,
      printedAt: printedAt ?? this.printedAt,
      printedById: printedById ?? this.printedById,
      printedByName: printedByName ?? this.printedByName,
      version: version ?? this.version,
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
      'printedAt': printedAt != null ? Timestamp.fromDate(printedAt!) : null,
      'printedById': printedById,
      'printedByName': printedByName,
      'version': version,
    };
  }

  factory WarehousePrintJob.fromMap(Map<String, dynamic> data) {
    return WarehousePrintJob(
      invoiceId: data['invoiceId'] as String,
      invoiceNumber: (data['invoiceNumber'] as String?) ?? '',
      clientName: (data['clientName'] as String?) ?? '',
      invoiceDate: _readTimestamp(data['invoiceDate']) ?? DateTime.now(),
      itemCount: (data['itemCount'] as num?)?.toInt() ?? 0,
      totalPrice: (data['totalPrice'] as num?)?.toDouble() ?? 0,
      storagePath: (data['storagePath'] as String?) ?? '',
      status: (data['status'] as String?) ?? pendingStatus,
      createdAt: _readTimestamp(data['createdAt']) ?? DateTime.now(),
      createdById: (data['createdById'] as String?) ?? '',
      createdByName: (data['createdByName'] as String?) ?? '',
      printedAt: _readTimestamp(data['printedAt']),
      printedById: data['printedById'] as String?,
      printedByName: data['printedByName'] as String?,
      version: (data['version'] as num?)?.toInt() ?? 0,
    );
  }

  static DateTime? _readTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }
}
