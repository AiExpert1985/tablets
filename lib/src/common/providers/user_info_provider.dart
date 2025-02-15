import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/authentication/repository/accounts_repository.dart';

class UserInfoNotifier extends StateNotifier<UserInfo> {
  UserInfoNotifier()
      : super(UserInfo(
            null, null, null, null)); // Initialize with null or a default SalesmanInfo instance

  void setDbRef(String value) {
    state = UserInfo(state.name, value, state.email, state.privilage);
  }

  void setName(String value) {
    state = UserInfo(value, state.dbRef, state.email, state.privilage);
  }

  void setEmail(String value) {
    state = UserInfo(state.name, state.dbRef, value, state.privilage);
  }

  void setPrivilage(String value) {
    state = UserInfo(state.name, state.dbRef, state.email, value);
  }

  UserInfo get salesmanInfo => state;

  UserInfo get data => state;
}

// Create a provider for the SalesmanInfoNotifier
final userInfoProvider = StateNotifierProvider<UserInfoNotifier, UserInfo>((ref) {
  return UserInfoNotifier();
});

class UserInfo {
  UserInfo(this.name, this.dbRef, this.email, this.privilage);

  String? name;
  String? dbRef;
  String? email;
  String? privilage;
}

Future<void> loadUserInfo(WidgetRef ref) async {
  final accountsRepository = ref.read(accountsRepositoryProvider);
  final email = FirebaseAuth.instance.currentUser!.email;
  final accounts = await accountsRepository.fetchItemListAsMaps();
  final salesmanInfoNotifier = ref.read(userInfoProvider.notifier);
  var matchingAccounts = accounts.where((account) => account['email'] == email);
  if (matchingAccounts.isNotEmpty) {
    final dbRef = matchingAccounts.first['dbRef'];
    salesmanInfoNotifier.setDbRef(dbRef);
    final name = matchingAccounts.first['name'];
    salesmanInfoNotifier.setName(name);
    final email = matchingAccounts.first['email'];
    salesmanInfoNotifier.setEmail(email);
    final privilage = matchingAccounts.first['privilage'];
    salesmanInfoNotifier.setPrivilage(privilage);
  }
}
