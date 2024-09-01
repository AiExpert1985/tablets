import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/routers/routing_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Listen for Auth changes and .refresh the GoRouter [router]
  // when go router refresh, the redirect is called
  GoRouter router = RoutingService().router;
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    router.refresh();
  });

  runApp(
    ProviderScope(
      child: MyApp(router: router),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});
  final GoRouter router;

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routerConfig: router,
      );
}
