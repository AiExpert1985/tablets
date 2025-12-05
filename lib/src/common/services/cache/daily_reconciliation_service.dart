import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tablets/src/common/services/cache/screen_cache_update_service.dart';

class DailyReconciliationService {
  final ScreenCacheUpdateService _updateService;

  DailyReconciliationService(this._updateService);

  static const String _lastReconciliationKey = 'last_reconciliation_timestamp';
  Timer? _timer;

  void listAppStart() async {
    final prefs = await SharedPreferences.getInstance();
    final lastTimestamp = prefs.getInt(_lastReconciliationKey);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (lastTimestamp == null || (now - lastTimestamp) > 24 * 60 * 60 * 1000) {
      // It's been more than 24 hours (or first run).
      // Schedule reconciliation in 1 hour.
      _scheduleReconciliation();
    }
  }

  void _scheduleReconciliation() {
    // Cancel existing timer if any
    _timer?.cancel();

    // 1 hour delay
    _timer = Timer(const Duration(hours: 1), () async {
      await _runReconciliation();
    });
  }

  Future<void> _runReconciliation() async {
    // We need to trigger full recalculation.
    // The UpdateService deals with "affected" entities.
    // For reconciliation, we want to update ALL entities.

    // However, UpdateService currently works by dbRef.
    // Identifying "all" entities requires knowing all dbRefs.
    // We can iterate through the DbCaches (Product, Customer, Salesman).

    // Since this service is "Daily", performance is less critical than correctness,
    // but we still want to be efficient.

    // We probably need methods in UpdateService to "updateAllProducts", "updateAllCustomers", etc.
    // Or we iterate here if we have access to DbCaches.

    // For now, let's assume we can add a method to UpdateService `reconcileAll()`.
    await _updateService.reconcileAll();

    // Update timestamp
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        _lastReconciliationKey, DateTime.now().millisecondsSinceEpoch);
  }
}
