import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashigon_mobile_app/models/product.dart';

class TopRatedProductProvider extends StateNotifier<List<Product>> {
  TopRatedProductProvider() : super([]);

  void setProducts(List<Product> products) {
    state = products;
  }
}

final topRatedProductProvider =
    StateNotifierProvider<TopRatedProductProvider, List<Product>>((ref) {
      return TopRatedProductProvider();
    });
