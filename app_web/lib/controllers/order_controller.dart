import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_web/global_variable.dart';
import 'package:app_web/models/order.dart';

class OrderController {
  Future<List<Order>> loadOrders() async {
    try {
      // Send an http GET request to the server to fetch orders
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON data
        List<dynamic> data = jsonDecode(response.body);
        List<Order> orders =
            data.map((order) => Order.fromJson(order)).toList();
        return orders;
      } else {
        // If the server did not return a 200 OK response, throw an exception
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      // Handle any errors that occur during the HTTP request
      print('Error loading orders: $e');
      return [];
    }
  }
}
