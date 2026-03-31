import 'package:fashigon_mobile_app/models/product.dart';
import 'package:fashigon_mobile_app/global_variables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductController {
  // Define a function that return a future containing list of the product model objects.
  Future<List<Product>> loadPopularProducts() async {
    // Use a try block to handle any exceptions that might occur in the http request process

    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/popular-products'),
        // set the http headers for the request, specifying that the content type is json with the UTF-8 encoded.
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(response.body);

      // If the response status code is 200, parse the response body and return a list of Product objects.
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Product> products =
            data
                .map(
                  (product) => Product.fromMap(product as Map<String, dynamic>),
                )
                .toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load popular products');
      }
    } catch (e) {
      throw Exception('Error loading product: $e');
    }
  }

  // Api call to load products by category.
  Future<List<Product>> loadProductByCategory(String category) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products-by-category/$category'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Product> products =
            data
                .map(
                  (product) => Product.fromMap(product as Map<String, dynamic>),
                )
                .toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load products by category');
      }
    } catch (e) {
      throw Exception('Error loading product: $e');
    }
  }

  // Display related products by subcategory
  Future<List<Product>> loadRelatedProductsBySubcategory(
    String productId,
  ) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/related-products-by-subcategory/$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Product> relatedProducts =
            data
                .map(
                  (product) => Product.fromMap(product as Map<String, dynamic>),
                )
                .toList();
        return relatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load related products');
      }
    } catch (e) {
      throw Exception('Error related product: $e');
    }
  }

  // method to get the top 10 highest-rated products
  Future<List<Product>> loadTopRatedProduct() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/top-rated-products'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        List<Product> topRatedProducts =
            data
                .map(
                  (product) => Product.fromMap(product as Map<String, dynamic>),
                )
                .toList();
        return topRatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load top rated products');
      }
    } catch (e) {
      throw Exception('Error top rated product: $e');
    }
  }
}
