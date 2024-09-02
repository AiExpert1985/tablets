import 'package:flutter/material.dart';

class ReversedLogoutIcon extends StatelessWidget {
  const ReversedLogoutIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.flip(
      flipX: true,
      child: const Icon(
        Icons.logout,
        color: Colors.white,
      ),
    );
  }
}
