// StateNotifier for delivered order count
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashigon_mobile_app/controllers/order_controller.dart';
import 'package:fashigon_mobile_app/services/manage_http_response.dart';

class DeliveredOrderCountProvider extends StateNotifier<int> {
  DeliveredOrderCountProvider() : super(0);

  // Method to fetch delivered orders count

  Future<void> fetchDeliveredOrderCount(String buyerId, context) async {
    try {
      OrderController orderController = OrderController();
      int count = await orderController.getDeliveredOrderCount(
        buyerId: buyerId,
      );
      state = count;
    } catch (e) {
      showSnackBar(context, 'Error fetching delivered orders: $e');
    }
  }

  // Method to reset the count
  void resetCount() {
    state = 0;
  }
}

final deliveredOrderCountProvider =
    StateNotifierProvider<DeliveredOrderCountProvider, int>((ref) {
      return DeliveredOrderCountProvider();
    });
