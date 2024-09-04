import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/src/routers/go_router_refresh_stream.dart';
import 'package:tablets/src/features/authentication/presentation/view/login/login_screen.dart';
import 'package:tablets/src/features/authentication/presentation/view/users/add_user_popup.dart';
import 'package:tablets/src/features/authentication/presentation/view/users/users_screen.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    return GoRouter(
      initialLocation: '/home',
      redirect: (context, state) {
        final bool isLoggedIn = firebaseAuth.currentUser != null;
        final String currentLocation = state.uri.path;
        if (isLoggedIn) {
          if (currentLocation == '/login' || currentLocation == '/signup') {
            return '/home';
          }
        } else {
          if (currentLocation == '/signup') {
            return '/signup';
          } else {
            return '/login';
          }
        }
        return null;
      },
      refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
      routes: <GoRoute>[
        GoRoute(
          name: '/home',
          path: '/home',
          builder: (BuildContext context, GoRouterState state) =>
              const UsersScreen(),
        ),
        GoRoute(
          name: '/login',
          path: '/login',
          builder: (BuildContext context, GoRouterState state) =>
              const LoginScreen(),
        ),
        GoRoute(
          name: '/signup',
          path: '/signup',
          builder: (BuildContext context, GoRouterState state) =>
              const AddUserPopup(),
        ),
      ],
    );
  },
);
