import 'package:fashigon_mobile_app/views/main_screen.dart';
import 'package:fashigon_mobile_app/views/screens/authentication_screens/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fashigon_mobile_app/provider/user_provider.dart';
import 'package:flutter/material.dart';

void main() {
  // Run the flutter app wrapped in a ProviderScope for Riverpod state management.

  runApp(ProviderScope(child: const MyApp()));
}

// Root widget of the application, a consumerWidget to consume state change.

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // Method to check the token and set the user data if available.
  Future<void> _checkTokenAndSetUser(WidgetRef ref) async {
    // Obtain an instance of sharedPreference for local data storage.
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // Retrieve the authentication token and user data stroed locally.

    String? token = preferences.getString('auth_token');
    String? userJson = preferences.getString('user');

    // if both token and user data are available, update the user state.
    if (token != null && userJson != null) {
      ref.read(userProvider.notifier).setUser(userJson);
    } else {
      // If no token or user data is found, clear the user state.
      ref.read(userProvider.notifier).signOut();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _checkTokenAndSetUser(ref),
        builder: (context, snapshot) {
          // Check if the future is complete and return the appropriate screen.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final user = ref.watch(userProvider);

          return user != null ? MainScreen() : LoginScreen();
        },
      ),
    );
  }
}
