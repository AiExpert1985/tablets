import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/storage_repository.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/utils/utils.dart' as utils;

class CustomImagePicker {
  static Future<Uint8List?> selectImage({uploadingMethod, imageSource = 'gallery'}) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: false);

      if (result != null && result.files.isNotEmpty) {
        return result.files.first.bytes;
      }

      // final selectedImage = await ImagePicker().pickImage(
      //     source: imageSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
      //     imageQuality: 100,
      //     maxWidth: 150);
      // if (selectedImage != null) {
      //   return File(selectedImage.path);
      // }
    } catch (e) {
      utils.CustomDebug.print(message: e, stackTrace: StackTrace.current);
      return null;
    }
    return null;
  }
}

class ImageSliderNotifier extends StateNotifier<List<String>> {
  ImageSliderNotifier(this._imageStorage, super.state);
  final StorageRepository _imageStorage;
  List<String> addedUrls = [];
  List<String> removedUrls = [];

  void initialize({List<String>? urls}) {
    state = urls ?? [constants.DefaultImage.url];
    addedUrls = [];
    removedUrls = [];
  }

  void addImage() async {
    String? newUrl;
    String imageName = utils.StringOperations.generateRandomString();
    Uint8List? imageFile = await CustomImagePicker.selectImage();
    if (imageFile != null) {
      newUrl = await _imageStorage.uploadImage(fileName: imageName, file: imageFile);
    }
    if (newUrl != null) {
      state = [...state, newUrl];
      addedUrls.add(newUrl);
      return;
    }
  }

  void removeImage(int urlIndex) async {
    if (state[urlIndex] == constants.DefaultImage.url) return; // don't remove default image
    removedUrls.add(state[urlIndex]);
    List<String> tempList = [...state];
    tempList.removeAt(urlIndex);
    state = [...tempList];
  }

  List<String> savedUpdatedImages() {
    for (String url in removedUrls) {
      _imageStorage.deleteImage(url);
    }
    addedUrls = [];
    return state;
  }

  void close() {
    for (String url in addedUrls) {
      _imageStorage.deleteImage(url);
    }
  }
}

final imageSliderNotifierProvider = StateNotifierProvider<ImageSliderNotifier, List<String>>((ref) {
  final imageStorage = ref.read(imageStorageProvider);
  return ImageSliderNotifier(imageStorage, []);
});
