import 'package:fashigon_vendor_store/models/vendor.dart';
import 'package:fashigon_vendor_store/services/manage_http_response.dart';
import 'package:fashigon_vendor_store/global_variables.dart';
import 'package:fashigon_vendor_store/views/screens/main_vendor_screen.dart';
import 'package:fashigon_vendor_store/provider/vendor_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final providerContainer = ProviderContainer();

class VendorAuthController {
  Future<void> signUpVendor({
    required String fullName,
    required String email,
    required String password,
    required context,
  }) async {
    try {
      Vendor vendor = Vendor(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        role: '',
        password: password,
      );
      await http
          .post(
            Uri.parse('$uri/api/vendor/signup'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: vendor.toJson(),
          )
          .then((response) {
            if (response.statusCode == 200) {
              // If the server did return a 200 OK response, then parse the JSON.
              showSnackBar(context, 'Vendor account created successfully');
            } else {
              // If the server did not return a 200 OK response, then throw an exception.
              showSnackBar(context, 'Failed to create vendor account');
            }
          });
    } catch (e) {}
  }

  // Function to consume the backend vendor signin api.
  Future<void> signInVendor({
    required String email,
    required String password,
    required context,
  }) async {
    try {
      await http
          .post(
            Uri.parse('$uri/api/vendor/signin'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'email': email,
              'password': password,
            }),
          )
          .then((response) {
            manageHttpResponse(
              response: response,
              context: context,
              onSuccess: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                // extract the authentication token from the response body.
                String token = jsonDecode(response.body)['token'];
                // Store the authentication token securely in sharedPreferences.
                await preferences.setString('auth_token', token);
                // Encode the user data received from the backend as Json.

                final vendorJson = jsonEncode(
                  jsonDecode(response.body)['vendor'],
                );

                // Update the application state with the user data using Riverpod.
                providerContainer
                    .read(vendorProvider.notifier)
                    .setVendor(vendorJson);

                // Store the data in sharedPreferences.
                await preferences.setString('vendor', vendorJson);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const MainVendorScreen();
                    },
                  ),
                  (route) => false,
                );
                showSnackBar(context, 'Vendor signed in successfully');
              },
            );
          });
    } catch (e) {
      showSnackBar(context, '$e');
    }
  }
}
