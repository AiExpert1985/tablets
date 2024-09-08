import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';

class MainDrawerHeader extends StatelessWidget {
  const MainDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ],
        ),
      ),

          child: Column(
            children: [
              SizedBox(
                  // margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  height: 120,
                  child: Image.asset('assets/images/tablets.png', fit: BoxFit.scaleDown),
                ),
              Text(
                S.of(context).slogan,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),

    );
  }
}
