import 'package:tablets/src/common/interfaces/base_item.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;

class Vendor implements BaseItem {
  @override
  String dbRef;
  @override
  String name;
  @override
  List<String> imageUrls;

  Vendor({
    required this.dbRef,
    required this.name,
    required this.imageUrls,
  });

  @override
  String get coverImageUrl => imageUrls.isNotEmpty ? imageUrls[imageUrls.length - 1] : constants.defaultImageUrl;

  @override
  Map<String, dynamic> toMap() {
    return {
      'dbRef': dbRef,
      'name': name,
      'imageUrls': imageUrls,
    };
  }

  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      dbRef: map['dbRef'] ?? '',
      name: map['name'] ?? '',
      imageUrls: List<String>.from(map['imageUrls']),
    );
  }

  @override
  String toString() => 'ProductCategory(dbRef: $dbRef, name: $name, imageUrls: $imageUrls)';
}
