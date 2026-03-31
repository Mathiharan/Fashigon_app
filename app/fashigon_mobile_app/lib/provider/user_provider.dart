import 'package:flutter_riverpod/flutter_riverpod.dart  ';
import 'package:fashigon_mobile_app/models/user.dart';

class UserProvider extends StateNotifier<User?> {
  // Constructor initializing with a default User object.
  // Purpose: Manage the state of the user object allowing updates.
  UserProvider()
    : super(
        User(
          id: '',
          fullname: '',
          email: '',
          state: '',
          city: '',
          locality: '',
          password: '',
          token: '',
        ),
      );

  // Getter method to extract value from an object
  User? get user => state;

  // Method to set the user state from json
  // Purpose: Update the user state based on the json string representation of the user object.

  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }

  // Method to clear user state
  void signOut() {
    // Purpose: Reset the user state to null when signing out.
    state = null;
  }

  //Method to recreate the user state.
  void recreateUserState({
    required String state,
    required String city,
    required String locality,
  }) {
    if (this.state != null) {
      this.state = User(
        id: this.state!.id,
        fullname: this.state!.fullname,
        email: this.state!.email,
        state: state,
        city: city,
        locality: locality,
        password: this.state!.password,
        token: this.state!.token,
      );
    }
  }
}

// make the data accessible to the app
final userProvider = StateNotifierProvider<UserProvider, User?>(
  (ref) => UserProvider(),
);
