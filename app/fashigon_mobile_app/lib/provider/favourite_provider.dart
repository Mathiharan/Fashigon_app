import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashigon_mobile_app/models/favourite.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favouriteProvider =
    StateNotifierProvider<FavouriteNotifier, Map<String, Favourite>>(
      (ref) => FavouriteNotifier(),
    );

class FavouriteNotifier extends StateNotifier<Map<String, Favourite>> {
  FavouriteNotifier() : super({}) {
    _loadFavourites();
  }

  // A private method that loads items from sharedPreferences
  Future<void> _loadFavourites() async {
    // Retrieving the sharedPreferences instance to load data
    final prefs = await SharedPreferences.getInstance();
    // Getting the json String from sharedPreferences
    final favouriteString = prefs.getString('favourites');

    if (favouriteString != null) {
      // Decoding the json String into a Map
      final Map<String, dynamic> favouritesMap = jsonDecode(favouriteString);

      // Converting the Map into a Map of Favourite objects
      final favourites = favouritesMap.map(
        (key, value) => MapEntry(key, Favourite.fromJson(value)),
      );
      // Setting the state with the loaded favourites
      state = favourites;
    }
  }

  // A private method that saves the current list of favourite items to sharedPreferences
  Future<void> _saveFavourites() async {
    // Retrieving the sharedPreferences instance to store data
    final prefs = await SharedPreferences.getInstance();
    // Encoding the current state (Map of favourite object) into json String.
    final favouriteString = jsonEncode(state);
    // Saving the json String to sharedPreferences
    await prefs.setString('favourites', favouriteString);
  }

  // Add a product to favourites
  void addProductToFavourite({
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
    state[productId] = Favourite(
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
    );

    // Notify listeners about the change
    state = {...state};
    _saveFavourites();
  }

  // Method to remove a product from the Favourite
  void removeFavouriteItem(String productId) {
    // Check if the product is in the Favourite
    if (state.containsKey(productId)) {
      // If it is, remove it from the Favourite
      state.remove(productId);

      //Notify listeners about the change
      state = {...state};
      _saveFavourites();
    }
  }

  Map<String, Favourite> get getFavouriteItems => state;
}
