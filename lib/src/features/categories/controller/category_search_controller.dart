// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CategoryController {
//   CategoryController();
// }

// class PickedImageNotifier extends StateNotifier<File?> {
//   PickedImageNotifier(super.state);
//   Future<void> updatePickedImage({imageSource = 'gallery'}) async {
//     try {
//       final pickedImage = await ImagePicker().pickImage(
//           source: imageSource == 'camera'
//               ? ImageSource.camera
//               : ImageSource.gallery,
//           imageQuality: 50,
//           maxWidth: 150); // can use ImageSource.gallery

//       // if camera is closed without taking a photo, we just return and do nothing
//       if (pickedImage != null) {
//         state = File(pickedImage.path);
//       }
//     } catch (e) {
//       utils.CustomDebug.print(
//           message: 'error while importing images',
//           stackTrace: StackTrace.current);
//     }
//   }

//   // file is null
//   void reset() {
//     state = null;
//   }
// }

// /// provide File if user used ImagePicker to select an image from the galary or camera
// /// otherwise it is null
// final pickedImageNotifierProvider =
//     StateNotifierProvider<PickedImageNotifier, File?>((ref) {
//   return PickedImageNotifier(null);
// });
