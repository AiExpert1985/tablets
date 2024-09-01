import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/routers/go_router_refresh_stream.dart';
import 'package:tablets/screens/login_screen/login_screen.dart';
import 'package:tablets/screens/signup_screen/signup_screen.dart';
import 'package:tablets/screens/home_screen/home_screen.dart';

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: '/home',
      redirect: (context, state) {
        final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
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
      refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
      routes: <GoRoute>[
        GoRoute(
          name: '/home',
          path: '/home',
          builder: (BuildContext context, GoRouterState state) =>
              const HomeScreen(),
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
              const SignupScreen(),
        ),
      ],

    );
  },
);
