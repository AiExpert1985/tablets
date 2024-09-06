import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/src/features/products/presentation/products_screen.dart';
import 'package:tablets/src/features/salesmen_live_locations/presentation/sales_men_live_location_screen.dart';
import 'package:tablets/src/features/transaction/presentation/transaction_screen.dart';
import 'package:tablets/src/routers/go_router_refresh_stream.dart';
import 'package:tablets/src/features/authentication/presentation/view/login/login_screen.dart';
import 'package:tablets/src/features/authentication/presentation/view/users/add_user_dialog.dart';
import 'package:tablets/src/routers/not_found_screen.dart';

enum AppRoute {
  home,
  login,
  signup,
  transactions,
  products,
}

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    return GoRouter(
      initialLocation: AppRoute.login.name,
      debugLogDiagnostics: true, // print route in the console
      redirect: (context, state) {
        final bool isLoggedIn = firebaseAuth.currentUser != null;
        final String currentLocation = state.uri.path;
        if (isLoggedIn) {
          if (currentLocation == '/login' || currentLocation == '/signup') {
            return AppRoute.home.name;
          }
        } else {
          if (currentLocation == '/signup') {
            return AppRoute.signup.name;
          } else {
            return AppRoute.login.name;
          }
        }
        return null;
      },
      refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
      routes: <GoRoute>[
        GoRoute(
          path: '/home',
          name: AppRoute.home.name,
          builder: (BuildContext context, GoRouterState state) =>
              const SalesmenLiveLocationScreen(),
        ),
        GoRoute(
          path: '/login',
          name: AppRoute.login.name,
          builder: (BuildContext context, GoRouterState state) =>
              const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          name: AppRoute.signup.name,
          builder: (BuildContext context, GoRouterState state) =>
              const AddUserPopup(),
        ),
        GoRoute(
          path: '/products',
          name: AppRoute.products.name,
          builder: (BuildContext context, GoRouterState state) =>
              const ProductsScreen(),
        ),
        GoRoute(
          path: '/transactions',
          name: AppRoute.transactions.name,
          builder: (BuildContext context, GoRouterState state) =>
              const TransactionsScreen(),
        ),
      ],
      errorBuilder: (context, state) => const NotFoundScreen(),
    );
  },
);
