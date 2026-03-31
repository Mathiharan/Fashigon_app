import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse({
  required http.Response response, // the HTTP response from the request
  required BuildContext context, // the context is to show snackbar
  required VoidCallback
  onSuccess, // the function to call when the response is successful
}) {
  // Switch statement to handle different http status codess
  switch (response.statusCode) {
    case 200: // OK
      onSuccess(); // Call the success function
      break;
    case 400: // Bad Request
      showSnackBar(context, json.decode(response.body)['message']);
      break;
    case 500: // Internal Server Error
      showSnackBar(context, json.decode(response.body)['error']);
      break;
    case 201: // Status code 201 indicates a resource was created successfully
      onSuccess();
      break; // Call the success function
  }
}

void showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.all(15),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.grey,
      content: Text(title),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}
