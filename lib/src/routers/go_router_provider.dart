import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/src/features/authentication/presentation/view/users/users_screen.dart';
import 'package:tablets/src/features/products/presentation/view/products_screen.dart';
import 'package:tablets/src/features/salesmen_live_locations/presentation/sales_men_live_location_screen.dart';
import 'package:tablets/src/features/settings/presentation/view/settings_screen.dart';
import 'package:tablets/src/features/transaction/presentation/transaction_screen.dart';
import 'package:tablets/src/routers/go_router_refresh_stream.dart';
import 'package:tablets/src/features/authentication/presentation/view/login/login_screen.dart';
import 'package:tablets/src/routers/not_found_screen.dart';

enum AppRoute {
  home,
  login,
  signup,
  transactions,
  products,
  salesmen,
  settings,
}

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    return GoRouter(
      initialLocation: '/login',
      // debugLogDiagnostics: true, // print route in the console
      redirect: (context, state) {
        final bool isLoggedIn = firebaseAuth.currentUser != null;
        final String currentLocation = state.uri.path;
        // if user isn't logged in, redirect to login page
        if (!isLoggedIn) {
          return '/login';
        }
        // if user is just logged in, redirect to home page
        if (currentLocation == '/login') {
          return '/home';
        }
        // otherwise, no redirection is needed, user will go as he intended
        return null;
        // i didn't use and redirect to signup, because user can't signup
        // only addmin can create new accounts
      },
      refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
      routes: <GoRoute>[
        GoRoute(
          path: '/home',
          name: AppRoute.home.name,
          builder: (BuildContext context, GoRouterState state) =>
              const ProductsScreen(),
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
              const UsersScreen(),
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
        GoRoute(
          path: '/salesmen',
          name: AppRoute.salesmen.name,
          builder: (BuildContext context, GoRouterState state) =>
              const SalesmenLiveLocationScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: AppRoute.settings.name,
          builder: (BuildContext context, GoRouterState state) =>
              const SettingsScreen(),
        ),
      ],
      errorBuilder: (context, state) => const NotFoundScreen(),
    );
  },
);
