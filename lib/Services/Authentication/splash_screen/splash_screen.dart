import 'package:flutter/material.dart';

// this screen is displayed only when the app connects with firebase.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splash screen'),
      ),
      body: const Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
