import 'package:fashigon_mobile_app/views/screens/nav_screens/widgets/banner_widget.dart';
import 'package:fashigon_mobile_app/views/screens/nav_screens/widgets/category_item_widget.dart';
import 'package:fashigon_mobile_app/views/screens/nav_screens/widgets/header_widget.dart';
import 'package:fashigon_mobile_app/views/screens/nav_screens/widgets/popular_widget.dart';
import 'package:fashigon_mobile_app/views/screens/nav_screens/widgets/reusable_text_widget.dart';
import 'package:fashigon_mobile_app/views/screens/nav_screens/widgets/top_rated_product_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.20,
        ),
        child: const HeaderWidget(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BannerWidget(),
            CategoryItemWidget(),
            ReusableTextWidget(title: 'Popular Products', subTitle: 'View all'),
            PopularProductWidget(),
            ReusableTextWidget(
              title: 'Top Rated Products',
              subTitle: 'View all',
            ),
            TopRatedProductWidget(),
          ],
        ),
      ),
    );
  }
}
