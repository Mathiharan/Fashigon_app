import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashigon_vendor_store/models/vendor.dart';

// StateNotifier is a class provided by Riverpod package that helps in managing the states.
// it is designed to notfy the listeners about the state changes.
class VendorProvider extends StateNotifier<Vendor?> {
  VendorProvider()
    : super(
        Vendor(
          id: '',
          fullName: '',
          email: '',
          state: '',
          city: '',
          locality: '',
          role: '',
          password: '',
        ),
      );

  // Getter method to extract value from an object
  Vendor? get vendor => state;

  // Method to set Vendor user state from Json.
  // Purpose: Update the user state based on JSON string representation of the vendor object.

  void setVendor(String vendorJson) {
    state = Vendor.fromJson(vendorJson);
  }

  // Method to clear the vendor user state.
  void signOut() {
    state = null;
  }
}

final vendorProvider = StateNotifierProvider<VendorProvider, Vendor?>((ref) {
  return VendorProvider();
});
