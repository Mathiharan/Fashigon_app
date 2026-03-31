import 'dart:convert';
import 'package:app_web/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:app_web/models/subcategory.dart';
import 'package:http/http.dart' as http;
import 'package:app_web/global_variable.dart';

class SubcategoryController {
  uploadSubcategory({
    required String categoryId,
    required String categoryName,
    required dynamic pickedImage,
    required String subCategoryName,
    required context,
  }) async {
    // Logic to upload subcategory
    try {
      final cloudinary = CloudinaryPublic('denbnijqe', 'mathi1234');

      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'pickedImage',
          folder: 'categoryImages',
        ),
      );

      String image = imageResponse.secureUrl;

      Subcategory subcategoryModel = Subcategory(
        id: "",
        categoryId: categoryId,
        categoryName: categoryName,
        image: image,
        subCategoryName: subCategoryName,
      );

      http.Response response = await http.post(
        Uri.parse('$uri/api/subcategories'),
        body: subcategoryModel.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Subcategory Uploaded');
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<List<Subcategory>> loadSubCategories() async {
    try {
      // send an http request to the backend to get the categories
      http.Response response = await http.get(
        Uri.parse('$uri/api/subcategories'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<Subcategory> subcategories =
            data
                .map((subcategory) => Subcategory.fromJson(subcategory))
                .toList();
        return subcategories;
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (e) {
      throw Exception('Error loading subcategories: $e');
    }
  }
}
