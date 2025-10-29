import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/warehouse_print_queue/model/warehouse_print_job.dart';

class WarehousePrintQueueRepository {
  WarehousePrintQueueRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final String _collectionName = 'warehouse_print_queue';
  final String _storageFolder = 'warehouse_invoices';

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionName);

  Reference _pdfRef(String invoiceId) =>
      _storage.ref().child('$_storageFolder/$invoiceId.pdf');

  Stream<WarehousePrintJob?> watchJob(String invoiceId) {
    return _collection.doc(invoiceId).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null || data.isEmpty) {
        return null;
      }
      return WarehousePrintJob.fromMap(data);
    });
  }

  Stream<List<WarehousePrintJob>> watchPendingJobs() {
    return _collection
        .where('status', isEqualTo: WarehousePrintJob.pendingStatus)
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WarehousePrintJob.fromMap(doc.data()))
            .toList());
  }

  Future<void> uploadInvoice(WarehousePrintJob job, Uint8List pdfBytes) async {
    final docRef = _collection.doc(job.invoiceId);
    await _pdfRef(job.invoiceId).putData(
      pdfBytes,
      SettableMetadata(contentType: 'application/pdf'),
    );

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final currentVersion = snapshot.exists
          ? (snapshot.data()?['version'] as num?)?.toInt() ?? 0
          : 0;
      final data = job
          .copyWith(
            status: WarehousePrintJob.pendingStatus,
            printedAt: null,
            printedById: null,
            printedByName: null,
            version: currentVersion + 1,
            createdAt: job.createdAt,
          )
          .toMap();
      transaction.set(docRef, data);
    });
  }

  Future<Uint8List> downloadPdf(String invoiceId) async {
    final ref = _pdfRef(invoiceId);
    final data = await ref.getData(5 * 1024 * 1024);
    if (data == null) {
      throw StateError('Missing invoice pdf for $invoiceId');
    }
    return data;
  }

  Future<void> markAsPrinted({
    required WarehousePrintJob job,
    required String printedById,
    required String printedByName,
  }) async {
    final docRef = _collection.doc(job.invoiceId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Invoice ${job.invoiceId} no longer exists');
      }
      final data = snapshot.data()!;
      final currentVersion = (data['version'] as num?)?.toInt() ?? 0;
      if (currentVersion != job.version) {
        throw StateError('Invoice ${job.invoiceId} was updated');
      }
      final updates = {
        'status': WarehousePrintJob.printedStatus,
        'printedAt': Timestamp.fromDate(DateTime.now()),
        'printedById': printedById,
        'printedByName': printedByName,
        'version': currentVersion + 1,
      };
      transaction.update(docRef, updates);
    });
  }
}

final warehousePrintQueueRepositoryProvider = Provider<WarehousePrintQueueRepository>((ref) {
  return WarehousePrintQueueRepository();
});
