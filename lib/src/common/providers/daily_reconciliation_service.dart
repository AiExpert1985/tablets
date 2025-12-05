import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/providers/screen_cache_service.dart';

/// Provider for the DailyReconciliationService
final dailyReconciliationServiceProvider = Provider<DailyReconciliationService>((ref) {
  return DailyReconciliationService(ref);
});

/// Service that handles daily automatic reconciliation of screen cache data
class DailyReconciliationService {
  DailyReconciliationService(this._ref);

  final Ref _ref;
  Timer? _reconciliationTimer;
  static const String _lastReconciliationKey = 'lastReconciliationTimestamp';
  static const int _reconciliationIntervalHours = 24;
  static const int _delayBeforeReconciliationMinutes = 60; // 1 hour delay

  /// Check if reconciliation is needed and schedule it if so
  /// Call this when the app starts
  Future<void> checkAndScheduleReconciliation(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastReconciliation = prefs.getInt(_lastReconciliationKey);

      if (lastReconciliation == null) {
        // First time - save current timestamp and don't reconcile yet
        await _updateLastReconciliationTimestamp();
        debugLog('First app start - no reconciliation needed');
        return;
      }

      final lastReconciliationDate = DateTime.fromMillisecondsSinceEpoch(lastReconciliation);
      final hoursSinceLastReconciliation = DateTime.now().difference(lastReconciliationDate).inHours;

      debugLog('Hours since last reconciliation: $hoursSinceLastReconciliation');

      if (hoursSinceLastReconciliation >= _reconciliationIntervalHours) {
        debugLog('Scheduling reconciliation after $_delayBeforeReconciliationMinutes minutes');
        _scheduleReconciliation(context);
      } else {
        debugLog('No reconciliation needed yet');
      }
    } catch (e) {
      errorPrint('Error checking reconciliation schedule: $e');
    }
  }

  /// Schedule reconciliation after delay
  void _scheduleReconciliation(BuildContext context) {
    _reconciliationTimer?.cancel();
    _reconciliationTimer = Timer(
      Duration(minutes: _delayBeforeReconciliationMinutes),
      () => _runReconciliation(context),
    );
  }

  /// Run the actual reconciliation
  Future<void> _runReconciliation(BuildContext context) async {
    try {
      debugLog('Starting scheduled daily reconciliation...');

      final cacheService = _ref.read(screenCacheServiceProvider);

      // Refresh all screen data
      await cacheService.refreshAllScreenData(context);

      // Update timestamp
      await _updateLastReconciliationTimestamp();

      debugLog('Daily reconciliation completed successfully');
    } catch (e) {
      errorPrint('Error during daily reconciliation: $e');
    }
  }

  /// Update the last reconciliation timestamp
  Future<void> _updateLastReconciliationTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastReconciliationKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Cancel any scheduled reconciliation
  void cancelScheduledReconciliation() {
    _reconciliationTimer?.cancel();
    _reconciliationTimer = null;
  }

  /// Force run reconciliation immediately (for manual trigger)
  Future<void> forceReconciliation(BuildContext context) async {
    debugLog('Force running reconciliation...');
    await _runReconciliation(context);
  }

  /// Get the last reconciliation date
  Future<DateTime?> getLastReconciliationDate() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReconciliation = prefs.getInt(_lastReconciliationKey);
    if (lastReconciliation == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(lastReconciliation);
  }
}
