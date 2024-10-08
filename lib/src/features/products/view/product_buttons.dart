import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ProductButtons extends StatelessWidget {
  const ProductButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 28.0),
      backgroundColor: Colors.green[900],
      visible: true,
      curve: Curves.bounceInOut,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.chrome_reader_mode, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => print('Pressed Read Later'),
          label: 'Read',
          labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
        SpeedDialChild(
          child: const Icon(Icons.create, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => print('Pressed Write'),
          label: 'Write',
          labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
        SpeedDialChild(
          child: const Icon(Icons.laptop_chromebook, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => print('Pressed Code'),
          label: 'Code',
          labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
      ],
    );
  }
}
