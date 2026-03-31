import 'package:fashigon_vendor_store/models/order.dart';
import 'package:fashigon_vendor_store/global_variables.dart';
import 'package:fashigon_vendor_store/services/manage_http_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController {
  // Method to GET Orders by vendor id.

  Future<List<Order>> loadOrders({required String vendorId}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? token = sharedPreferences.getString('auth_token');
      // Send an HTTP GET request to get the orders by the vendorId
      final requestUri = Uri.parse('$uri/api/orders/vendors/$vendorId');
      print('Fetching orders for vendorId: $vendorId');
      print('Request URI: $requestUri');
      http.Response response = await http.get(
        requestUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Check if the response status code is 200(OK).
      if (response.statusCode == 200) {
        // Parse the Json response body into dynamic List.
        // This convert the json data into a format that can be further processed in Dart.
        List<dynamic> data = jsonDecode(response.body);
        // Map the dynamic list to list of Orders object using the fromJson factory method
        // This step converts the raw data into list of the orders instances, which are easier to work with
        List<Order> orders =
            data.map((order) => Order.fromJson(order)).toList();

        return orders;
      }
      {
        //throw an exception if the server responded with an error status code.
        throw Exception("Failed to load Orders");
      }
    } catch (e) {
      throw Exception('Error loading orders: $e');
    }
  }

  // Delete order by ID.
  Future<void> deleteOrder({required String id, required context}) async {
    try {
      http.Response response = await http.delete(
        Uri.parse('$uri/api/orders/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Order deleted successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> updateDeliveryStatus({
    required String id,
    required context,
  }) async {
    try {
      http.Response response = await http.patch(
        Uri.parse('$uri/api/orders/$id/delivered'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"delivered": true, "processing": false}),
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Order updated successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> cancelOrder({required String id, required context}) async {
    try {
      http.Response response = await http.patch(
        Uri.parse('$uri/api/orders/$id/processing'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"processing": false, "delivered": false}),
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Order Cancelled');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
