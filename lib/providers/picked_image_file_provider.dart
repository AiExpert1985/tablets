import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pickedImageFileProvider = StateProvider<File?>((ref){
  return null;
});