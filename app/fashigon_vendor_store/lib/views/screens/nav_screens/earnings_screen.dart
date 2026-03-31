import 'package:fashigon_vendor_store/provider/total_earnings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashigon_vendor_store/provider/vendor_provider.dart';
import 'package:fashigon_vendor_store/provider/order_provider.dart';
import 'package:fashigon_vendor_store/controllers/order_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch orders when the screen is initialized.
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    // This function will be used to fetch orders from the server.
    // You can implement the logic to fetch orders here.
    final user = ref.read(vendorProvider);
    if (user == null) {
      // User data is still loading, so try again after a short delay.
      await Future.delayed(const Duration(milliseconds: 200));
      return _fetchOrders();
    }
    final OrderController orderController = OrderController();
    try {
      print('Fetching orders for vendor id: ${user.id}');
      final orders = await orderController.loadOrders(vendorId: user.id);
      print('Orders fetched: $orders');
      ref.read(orderProvider.notifier).setOrders(orders);
      ref.read(totalEarningsProvider.notifier).calculateEarnings(orders);
      print('Orders set in provider');
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendor = ref.watch(vendorProvider);
    final totalEarnings = ref.watch(totalEarningsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(
                vendor!.fullName[0].toUpperCase(),
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 200,
              child: Text(
                'Welcome! ${vendor.fullName}',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Orders',
                style: GoogleFonts.montserrat(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                '${totalEarnings['totalOrders']}',
                style: GoogleFonts.montserrat(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Total Earnings',
                style: GoogleFonts.montserrat(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                '\Rs.${totalEarnings['totalEarnings'].toStringAsFixed(2)}',
                style: GoogleFonts.montserrat(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
