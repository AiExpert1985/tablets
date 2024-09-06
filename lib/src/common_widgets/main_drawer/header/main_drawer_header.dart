import 'package:flutter/material.dart';

class MainDrawerHeader extends StatelessWidget {
  const MainDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(255, 248, 99, 99),
            const Color.fromARGB(255, 248, 99, 99).withOpacity(0.7),
          ],
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.fastfood,
            size: 48,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            'Cooking up!',
            style: TextStyle(fontSize: 28),
          ),
        ],
      ),
    );
  }
}
