import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/Services/Authentication/login_screen/login_screen.dart';
import 'package:tablets/Services/Authentication/signup_screen/signup_screen.dart';
import 'package:tablets/screens/home_screen/home_screen.dart';

class RoutingService {
  final router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/home',
        name: '/home',
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: '/signup',
        builder: (BuildContext context, GoRouterState state) =>
            const SignupScreen(),
      ),
    ],

    // redirect to the login page if the user is not logged in
    redirect: (BuildContext context, GoRouterState state) async {
      final bool loggedIn = FirebaseAuth.instance.currentUser != null;
      final bool loggingIn = state.matchedLocation == '/login';
      if (!loggedIn && state.matchedLocation == '/signup') return '/signup';
      if (!loggedIn) return '/login';
      if (loggingIn) return '/home';
      // no need to redirect at all
      return null;
    },
  );
}
