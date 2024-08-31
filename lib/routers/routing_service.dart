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
      // if user not logged in, and press 'signup' button, will be taken to signup screen
      if (!loggedIn && state.matchedLocation == '/signup') return '/signup';
      // if user not logged in, it will be taken to 'login' screen
      if (!loggedIn) return '/login';
      // if user logged in, and is in 'login' screen, he will be taken to 'home' screen
      if (state.matchedLocation == '/login') return '/home';
      return null;
    },
  );
}
