import 'dart:convert';
import 'package:fashigon_vendor_store/global_variables.dart';
import 'package:fashigon_vendor_store/models/subcategory.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
  Future<List<Subcategory>> getSubcategoriesByCategoryName(
    String categoryName,
  ) async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/category/$categoryName/subcategories"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data
              .map((subcategory) => Subcategory.fromJson(subcategory))
              .toList();
        } else {
          print("subcategories not found");
          return []; // Return an empty list if no subcategories found
        }
      } else if (response.statusCode == 404) {
        print("subcategories not found");
        return []; // Return an empty list if no subcategories found
      } else {
        print("Failed to fetch subcategories");
        return []; // Return an empty list if the request fails
      }
    } catch (e) {
      print("An error occurred: $e");
      return [];
    }
  }
}
