import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashigon_mobile_app/models/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a stateNotifier provider for managing the cart state
// Making it accessible to the app
final cartProvider = StateNotifierProvider<CartNotifier, Map<String, Cart>>(
  (ref) => CartNotifier(),
);

// A notifier class to managae the cart state, extending stateNotifier with an
// initial state of an empty map.
class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({}) {
    _loadCartItems();
  }

  // A private method that loads items from sharedPreferences
  Future<void> _loadCartItems() async {
    // Retrieving the sharedPreferences instance to load data
    final prefs = await SharedPreferences.getInstance();
    // Getting the json String from sharedPreferences
    final cartString = prefs.getString('cart_items');

    if (cartString != null) {
      // Decoding the json String into a Map
      final Map<String, dynamic> cartMap = jsonDecode(cartString);

      // Converting the Map into a Map of Favourite objects
      final cartItems = cartMap.map(
        (key, value) => MapEntry(key, Cart.fromJson(value)),
      );
      // Setting the state with the loaded cartItems
      state = cartItems;
    }
  }

  // A private method that saves the current list of Cart items to sharedPreferences
  Future<void> _saveCartIems() async {
    // Retrieving the sharedPreferences instance to store data
    final prefs = await SharedPreferences.getInstance();
    // Encoding the current state (Map of favourite object) into json String.
    final cartString = jsonEncode(state);
    // Saving the json String to sharedPreferences
    await prefs.setString('cart_items', cartString);
  }

  // Method to add product to the cart
  void addProductToCart({
    required String productName,
    required int productPrice,
    required String category,
    required List<String> image,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
    required String fullName,
  }) {
    //check if the product is already in the cart
    if (state.containsKey(productId)) {
      //if it is, update the quantity
      state = {
        ...state,
        productId: Cart(
          productName: state[productId]!.productName,
          productPrice: state[productId]!.productPrice,
          category: state[productId]!.category,
          image: state[productId]!.image,
          vendorId: state[productId]!.vendorId,
          productQuantity: state[productId]!.productQuantity,
          quantity: state[productId]!.quantity + 1,
          productId: state[productId]!.productId,
          description: state[productId]!.description,
          fullName: state[productId]!.fullName,
        ),
      };
      _saveCartIems();
    } else {
      // If the product is not in the cart, add it with the provided details
      state = {
        ...state,
        productId: Cart(
          productName: productName,
          productPrice: productPrice,
          category: category,
          image: image,
          vendorId: vendorId,
          productQuantity: productQuantity,
          quantity: quantity,
          productId: productId,
          description: description,
          fullName: fullName,
        ),
      };
    }
  }

  // Method to increment the quantity of a product in the cart
  void incrementCartItem(String productId) {
    // Check if the product is in the cart
    if (state.containsKey(productId)) {
      // If it is, update the quantity
      state[productId]!.quantity++;

      // Notify listeners about the change
      state = {...state};
      _saveCartIems();
    }
    ;
  }

  // Method to decrement the quantity of a product in the cart
  void decrementCartItem(String productId) {
    // Check if the product is in the cart
    if (state.containsKey(productId)) {
      // If it is, update the quantity
      state[productId]!.quantity--;

      // Notify listeners about the change
      state = {...state};
      _saveCartIems();
    }
  }

  // Method to remove a product from the cart
  void removeCartItem(String productId) {
    // Check if the product is in the cart
    if (state.containsKey(productId)) {
      // If it is, remove it from the cart
      state.remove(productId);

      //Notify listeners about the change
      state = {...state};
      _saveCartIems();
    }
  }

  // Method to calculate the total price of all items in the cart
  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.quantity * cartItem.productPrice;
    });

    return totalAmount;
  }

  // Method to clear all items from the cart
  void clearCart() {
    state = {};
    // Notify Listeners that the state has changed.

    state = {...state};
    _saveCartIems();
  }

  Map<String, Cart> get getCartItems => state;
}
