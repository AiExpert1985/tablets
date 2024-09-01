import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/screens/login_screen/login_screen.dart';
import 'package:tablets/screens/signup_screen/signup_screen.dart';
import 'package:tablets/screens/home_screen/home_screen.dart';

class RoutingService {
  final router = GoRouter(
    initialLocation: '/home',
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

    // this redirect is triggered with changes in the user authentication
    redirect: (BuildContext context, GoRouterState state) {
      // check whether the user is logged in
      final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final String currentLocation = state.uri.path;
      if (isLoggedIn) {
        if (currentLocation == '/login') {
          return '/home';
        }
      } else {
        return '/login';
      }
      return null;
    },
  );
}
