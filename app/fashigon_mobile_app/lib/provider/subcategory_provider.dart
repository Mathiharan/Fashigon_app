import 'package:fashigon_mobile_app/models/subcategory.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubcategoryProvider extends StateNotifier<List<Subcategory>> {
  SubcategoryProvider() : super([]);

  // Set the list of subcategories
  void setSubcategories(List<Subcategory> subcategories) {
    state = subcategories;
  }
}

final subcategoryProvider =
    StateNotifierProvider<SubcategoryProvider, List<Subcategory>>((ref) {
      return SubcategoryProvider();
    });
