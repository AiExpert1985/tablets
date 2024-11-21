import 'package:flutter_riverpod/flutter_riverpod.dart';

final vendorReportControllerProvider = Provider<VendorReportController>((ref) {
  return VendorReportController();
});

class VendorReportController {
  VendorReportController();
}
