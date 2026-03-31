import 'package:fashigon_mobile_app/controllers/product_controller.dart';
import 'package:fashigon_mobile_app/views/screens/detail/screens/widgets/inner_banner_widget.dart';
import 'package:fashigon_mobile_app/views/screens/detail/screens/widgets/inner_header_widget.dart';
import 'package:fashigon_mobile_app/views/screens/detail/screens/widgets/subcategory_tile_widget.dart';
import 'package:fashigon_mobile_app/views/screens/nav_screens/widgets/reusable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:fashigon_mobile_app/models/category.dart';
import 'package:fashigon_mobile_app/controllers/subcategory_controller.dart';
import 'package:fashigon_mobile_app/models/subcategory.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fashigon_mobile_app/models/product.dart';
import 'package:fashigon_mobile_app/views/screens/nav_screens/widgets/product_item_widget.dart';

class InnerCategoryContentWidget extends StatefulWidget {
  final Category category;

  const InnerCategoryContentWidget({super.key, required this.category});

  @override
  State<InnerCategoryContentWidget> createState() =>
      _InnerCategoryContentWidgetState();
}

class _InnerCategoryContentWidgetState
    extends State<InnerCategoryContentWidget> {
  late Future<List<Subcategory>> _subCategories;
  late Future<List<Product>> futureProducts;
  final SubcategoryController _subcategoryController = SubcategoryController();
  @override
  void initState() {
    super.initState();
    _subCategories = _subcategoryController.getSubcategoriesByCategoryName(
      widget.category.name,
    );
    futureProducts = ProductController().loadProductByCategory(
      widget.category.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: const InnerHeaderWidget(),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            InnerBannerWidget(image: widget.category.banner),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Shop By Categories',
                  style: GoogleFonts.quicksand(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            FutureBuilder(
              future: _subCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No subcategories available'),
                  );
                } else {
                  final subcategories = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: List.generate((subcategories.length / 7).ceil(), (
                        setIndex,
                      ) {
                        // For each row calculate the start and end index of the subcategories to be displayed
                        final start = setIndex * 7;
                        final end = (setIndex + 1) * 7;

                        // Create a padding widget to add spacing around the row
                        return Padding(
                          padding: EdgeInsets.all(8.9),
                          child: Row(
                            // create a row of subcategories tile
                            children:
                                subcategories
                                    .sublist(
                                      start,
                                      end > subcategories.length
                                          ? subcategories.length
                                          : end,
                                    )
                                    .map(
                                      (subcategory) => SubcategoryTileWidget(
                                        image: subcategory.image,
                                        title: subcategory.subCategoryName,
                                      ),
                                    )
                                    .toList(),
                          ),
                        );
                      }),
                    ),
                  );
                }
              },
            ),

            ReusableTextWidget(title: 'Popular Product', subTitle: 'View all'),

            FutureBuilder(
              future: futureProducts,
              builder: (context, snapshot) {
                // Check if the snapshot has data and is not in an error state.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No products under this category'),
                  );
                } else {
                  final products = snapshot.data;
                  return SizedBox(
                    height: 250, // Adjust the height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products!.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductItemWidget(product: product);
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
