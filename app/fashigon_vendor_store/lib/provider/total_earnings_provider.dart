import 'package:fashigon_vendor_store/models/order.dart'; // Assuming you have an Order model
import 'package:flutter_riverpod/flutter_riverpod.dart';
// A class that extends StateNotifier to manage the state of total earnings.

class TotalEarningsProvider extends StateNotifier<Map<String, dynamic>> {
  // Constructor initializes the state to 0.0
  TotalEarningsProvider() : super({'totalEarnings': 0.0, 'totalOrders': 0});

  // Method to calculate total earnings based on a list of orders
  void calculateEarnings(List<Order> orders) {
    double earnings = 0.0;
    int orderCount = 0;

    // Iterate through the orders and sum up the earnings from delivered orders
    for (Order order in orders) {
      if (order.delivered) {
        orderCount++;
        earnings += order.productPrice * order.quantity;
      }
    }
    // Update the state with the calculated earnings, which will notify listeners

    state = {'totalEarnings': earnings, 'totalOrders': orderCount};
  }
}

final totalEarningsProvider =
    StateNotifierProvider<TotalEarningsProvider, Map<String, dynamic>>((ref) {
      return TotalEarningsProvider();
    });
