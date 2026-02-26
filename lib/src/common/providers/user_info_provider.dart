// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/authentication/model/user_account.dart';
import 'package:tablets/src/features/authentication/repository/accounts_repository.dart';

class UserInfoNotifier extends StateNotifier<UserAccount?> {
  UserInfoNotifier() : super(null);

  DateTime? _lastFetchTime;
  static const _refreshInterval = Duration(minutes: 30);

  void setUserAccount(UserAccount userInfo) {
    state = userInfo;
  }

  bool hasPermission(List<String> allowedPrivilages) {
    if (state == null || !state!.hasAccess) {
      return false;
    }
    return allowedPrivilages.contains(state!.privilage) ||
        state!.privilage == UserPrivilage.admin.name;
  }

  void reset() {
    state = null;
    _lastFetchTime = null;
  }

  Future<void> loadUserInfo(WidgetRef ref, {bool forceRefresh = false}) async {
    // Skip fetching if user info was recently loaded (avoids reading entire accounts collection)
    // Still refresh every 30 minutes to check if user access was revoked by admin
    if (!forceRefresh && state != null && _lastFetchTime != null) {
      final elapsed = DateTime.now().difference(_lastFetchTime!);
      if (elapsed < _refreshInterval) return;
    }
    final accountsRepository = ref.read(accountsRepositoryProvider);
    final email = FirebaseAuth.instance.currentUser!.email;
    final accounts = await accountsRepository.fetchItemListAsMaps();
    var matchingAccounts = accounts.where((account) => account['email'] == email);
    if (matchingAccounts.isNotEmpty) {
      final dbRef = matchingAccounts.first['dbRef'];
      final name = matchingAccounts.first['name'];
      final email = matchingAccounts.first['email'];
      final privilage = matchingAccounts.first['privilage'];
      final hasAccess = matchingAccounts.first['hasAccess'];
      final userInfo = UserAccount(name, dbRef, email, privilage, hasAccess);
      setUserAccount(userInfo);
      _lastFetchTime = DateTime.now();
    }
  }
}

// Create a provider for the SalesmanInfoNotifier
final userInfoProvider = StateNotifierProvider<UserInfoNotifier, UserAccount?>((ref) {
  return UserInfoNotifier();
});
