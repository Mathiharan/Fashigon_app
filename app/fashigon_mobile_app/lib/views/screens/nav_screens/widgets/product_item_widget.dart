import 'package:fashigon_mobile_app/services/manage_http_response.dart';
import 'package:flutter/material.dart';
import 'package:fashigon_mobile_app/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fashigon_mobile_app/views/screens/detail/screens/product_detail_screen.dart';
import 'package:fashigon_mobile_app/provider/cart_provider.dart';
import 'package:fashigon_mobile_app/provider/favourite_provider.dart';

class ProductItemWidget extends ConsumerStatefulWidget {
  final Product product;

  const ProductItemWidget({super.key, required this.product});

  @override
  ConsumerState<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends ConsumerState<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.watch(cartProvider.notifier);
    final cartData = ref.watch(cartProvider);
    final isInCart = cartData.containsKey(widget.product.id);
    final favouriteProviderData = ref.watch(favouriteProvider.notifier);
    ref.watch(favouriteProvider);
    return InkWell(
      onTap: () {
        // Add your onTap logic here, e.g., navigate to product details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductDetailScreen(product: widget.product);
            },
          ),
        );
      },
      child: Container(
        width: 170,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image of the product
            Container(
              height: 170,
              decoration: BoxDecoration(
                color: const Color(0xffF2F2F2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Image.network(
                    widget.product.images[0],
                    height: 170,
                    width: 170,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 5,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        favouriteProviderData.addProductToFavourite(
                          productName: widget.product.productName,
                          productPrice: widget.product.productPrice,
                          category: widget.product.category,
                          image: widget.product.images,
                          vendorId: widget.product.vendorId,
                          productQuantity: widget.product.quantity,
                          quantity: 1,
                          productId: widget.product.id,
                          description: widget.product.description,
                          fullName: widget.product.fullName,
                        );
                        showSnackBar(
                          context,
                          '${widget.product.productName} added to favourites!',
                        );
                      },
                      child:
                          favouriteProviderData.getFavouriteItems.containsKey(
                                widget.product.id,
                              )
                              ? const Icon(Icons.favorite, color: Colors.red)
                              : const Icon(
                                Icons.favorite_border,
                                color: Colors.grey,
                              ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    height: 26,
                    width: 26,
                    child: InkWell(
                      onTap:
                          isInCart
                              ? null
                              : () {
                                cartProviderData.addProductToCart(
                                  productName: widget.product.productName,
                                  productPrice: widget.product.productPrice,
                                  category: widget.product.category,
                                  image: widget.product.images,
                                  vendorId: widget.product.vendorId,
                                  productQuantity: widget.product.quantity,
                                  quantity: 1,
                                  productId: widget.product.id,
                                  description: widget.product.description,
                                  fullName: widget.product.fullName,
                                );
                                showSnackBar(
                                  context,
                                  '${widget.product.productName} Added to Cart!',
                                );
                              },
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.product.productName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: const Color(0xFF212121),
                fontWeight: FontWeight.bold,
              ),
            ),
            widget.product.averageRating == 0
                ? SizedBox()
                : Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      widget.product.averageRating.toStringAsFixed(1),
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff868D94),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${widget.product.totalRatings})',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff868D94),
                      ),
                    ),
                  ],
                ),
            Text(
              widget.product.category,
              style: GoogleFonts.quicksand(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xff868D94),
              ),
            ),
            Text(
              '\R\s.${widget.product.productPrice.toStringAsFixed(2)}',
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
