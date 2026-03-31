import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:fashigon_vendor_store/global_variables.dart';
import 'package:fashigon_vendor_store/services/manage_http_response.dart';
import 'package:fashigon_vendor_store/models/product.dart'; // Import the Product model
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductController {
  Future<void> uploadProduct({
    required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<File>? pickedImages,
    required context,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('auth_token');
    if (pickedImages != null) {
      final cloudinary = CloudinaryPublic('denbnijqe', 'mathi1234');
      List<String> images = [];
      // loop through the images and upload them to cloudinary.
      for (var i = 0; i < pickedImages.length; i++) {
        CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedImages[i].path, folder: productName),

          //Add the secure URL to the images list.
        );
        images.add(cloudinaryResponse.secureUrl);
      }
      if (category.isNotEmpty && subCategory.isNotEmpty) {
        final Product product = Product(
          id: '',
          productName: productName,
          productPrice: productPrice,
          quantity: quantity,
          description: description,
          category: category,
          vendorId: vendorId,
          fullName: fullName,
          subCategory: subCategory,
          images: images,
        );
        http.Response response = await http.post(
          Uri.parse("$uri/api/add-product"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!,
          },
          body: product.toJson(),
        );
        manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Product uploaded');
          },
        );
      } else {
        showSnackBar(context, 'Select Category');
      }
    } else {
      showSnackBar(context, 'Select Image');
    }
  }
}
