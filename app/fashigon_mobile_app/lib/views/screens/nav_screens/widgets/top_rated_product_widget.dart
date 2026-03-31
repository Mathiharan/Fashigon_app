import 'package:fashigon_mobile_app/provider/top_rated_product_provider.dart';
import 'package:fashigon_mobile_app/views/screens/nav_screens/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:fashigon_mobile_app/controllers/product_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashigon_mobile_app/provider/product_provider.dart';

class TopRatedProductWidget extends ConsumerStatefulWidget {
  const TopRatedProductWidget({super.key});

  @override
  ConsumerState<TopRatedProductWidget> createState() =>
      _PopularProductWidgetState();
}

class _PopularProductWidgetState extends ConsumerState<TopRatedProductWidget> {
  // A Future that will hold the list of popular products.
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final products = ref.read(productProvider);
    if (products.isEmpty) {
      _fetchProduct();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProduct() async {
    final productController = ProductController();
    try {
      final products = await productController.loadTopRatedProduct();
      ref.read(topRatedProductProvider.notifier).setProducts(products);
    } catch (e) {
      // Handle any errors that occur during the fetch.
      print('Error fetching popular products: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(topRatedProductProvider);
    return SizedBox(
      height: 250, // Adjust the height as needed
      child:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              )
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductItemWidget(product: product);
                },
              ),
    );
  }
}
