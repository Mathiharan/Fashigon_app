import 'dart:convert';
import 'package:fashigon_mobile_app/models/user.dart';
import 'package:fashigon_mobile_app/global_variables.dart';
import 'package:fashigon_mobile_app/services/manage_http_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:fashigon_mobile_app/views/screens/authentication_screens/login_screen.dart'; // Import LoginScreen
import 'package:fashigon_mobile_app/views/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import MainScreen
import 'package:fashigon_mobile_app/provider/user_provider.dart';
import 'package:fashigon_mobile_app/provider/delivered_order_count_provider.dart';

class AuthController {
  Future<void> signUpUsers({
    required BuildContext context,
    required String email,
    required String fullname,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        fullname: fullname,
        email: email,
        state: '',
        city: '',
        locality: '',
        password: password,
        token: '',
      );

      print('Uri: {$uri}');
      print('Serialized User: ${user.toJson()}');
      http.Response response; // Declare response variable here
      try {
        response = await http.post(
          Uri.parse('$uri/api/signup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, // Set the headers for the request
        );
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      } catch (e) {
        print('HTTP request failed: $e');
        if (e is http.ClientException) {
          print('ClientException details: ${e.message}');
        }
        showSnackBar(context, 'Failed to connect to the server: $e');
        return; // Exit the function if the request fails
      }

      // Convert the user object to Json for the request body.

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
          showSnackBar(context, 'Account has been created for you!');
        },
      );
    } catch (e) {
      print('Error occurred: $e');
      showSnackBar(context, 'An error occurred: $e');
    }
  }

  // Sign in users function
  Future<void> signInUsers({
    required BuildContext context,
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/signin"),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          // Access sharedPreferences for token and user data storage.
          SharedPreferences preferences = await SharedPreferences.getInstance();

          // Extract the authentication token from the response body.
          String token = jsonDecode(response.body)['token'];

          // Store the authentication token securely in shared preferences.
          await preferences.setString('auth_token', token);

          //Encode the user data received from the backend as json.
          final userJson = jsonEncode(jsonDecode(response.body)['user']);

          // Update the application state with the user data using Riverpod.
          ref.read(userProvider.notifier).setUser(userJson);

          // Store the data in sharedPreferences for future use.
          await preferences.setString('user', userJson);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false,
          );
          showSnackBar(context, 'Logged In successfully!');
        },
      );
    } catch (e) {}
  }

  // Signout

  Future<void> signOutUser({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // Clear all stored data in shared preferences.
      await preferences.remove('auth_token');
      await preferences.remove('user');
      // Clear the user state.
      ref.read(deliveredOrderCountProvider.notifier).resetCount();

      // Navigate the user back to the login screen.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );

      showSnackBar(context, 'Signout successfully!');
    } catch (e, stackTrace) {
      print('Error signing out: $e\n$stackTrace');
      showSnackBar(context, "Error signing out");
    }
  }

  // Update user's state, city and locality.
  Future<void> updatedUserLocation({
    required BuildContext context,
    required String id,
    required String state,
    required String city,
    required String locality,
    required WidgetRef ref,
  }) async {
    try {
      //Make an HTTP PUT request to update user's state, city and locality
      final http.Response response = await http.put(
        Uri.parse('$uri/api/users/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'state': state, 'city': city, 'locality': locality}),
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          // Decode the updated user data from the response body
          // This converts the json String response into Dart Map
          final updatedUser = jsonDecode(response.body);

          // Access shared preferences for local data storage.
          // Shared preferences allow us to store data persistently on the device.
          SharedPreferences preferences = await SharedPreferences.getInstance();

          // Encode the updated user data as Json String.
          // This prepares the data for storage in shared preference.
          final userJson = jsonEncode(updatedUser);

          // Update the application state with the updated user data using Riverpod
          // This ensures the app reflects the most recent user data.
          ref.read(userProvider.notifier).setUser(userJson);

          // Store the updated user data in shared preference for future use.
          // This allows the app to retrieve the user data even after the app restarts.
          await preferences.setString('user', userJson);
        },
      );
    } catch (e) {
      // Catch any error that occur during the process.
      // Show an error message to the user if the update fails.
      showSnackBar(context, 'Error updating location');
    }
  }
}
