import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashigon_vendor_store/models/order.dart';

class OrderProvider extends StateNotifier<List<Order>> {
  OrderProvider() : super([]);

  // Set the list of Orders.
  void setOrders(List<Order> orders) {
    state = orders;
  }

  void updateOrderStatus(String orderId, {bool? processing, bool? delivered}) {
    //Update the state of the provider with a new list of orders.
    state = [
      // Iterate through the exisiting orders.
      for (final order in state)
        // Check if the current orders ID matches the ID we want to update.
        if (order.id == orderId)
          // Create new Order object with the updated status.
          Order(
            id: order.id,
            fullName: order.fullName,
            email: order.email,
            state: order.state,
            city: order.city,
            locality: order.locality,
            productName: order.productName,
            productPrice: order.productPrice,
            quantity: order.quantity,
            category: order.category,
            image: order.image,
            buyerId: order.buyerId,
            vendorId: order.vendorId,
            // Use the new processing status if provided, otherwise keep the current state.
            processing: processing ?? order.processing,
            // Use the new delivered status if provided, otherwise keep the current state.
            delivered: delivered ?? order.delivered,
          )
        // If the current order's ID does not match, keep the order unchange.
        else
          order,
    ];
  }
}

final orderProvider = StateNotifierProvider<OrderProvider, List<Order>>((ref) {
  return OrderProvider();
});
