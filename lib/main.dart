import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:tablets/screens/home_screen/home_screen.dart';
import 'package:tablets/Services/Authentication/splash_screen/splash_screen.dart';
import 'package:tablets/Services/Authentication/login_screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        // stream is a listener to any change in firebase authentication
        stream: FirebaseAuth.instance.authStateChanges(),
        // you can think of snapshot as user data created by firebase
        builder: (ctx, snapshot) {
          // display a temp screen while firebase is checking where user is logged in
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          // if snapshot has data, means the user is logged in
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
