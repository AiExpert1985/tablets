import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Guards the startup "missing transactions from print log" check so it only
/// runs (and alerts) once per app session, the same pattern used by
/// dailyDatabaseBackupNotifier for the daily backup.
final missingTransactionsCheckedNotifier = StateProvider<bool>((ref) => false);
