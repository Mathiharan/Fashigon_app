import 'dart:convert';

class Buyer {
  final String id;
  final String fullname;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;
  final String token;

  Buyer({
    required this.id,
    required this.fullname,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.password,
    required this.token,
  });

  // Serialization: Convert a Buyer object to a Map
  // Map: A Map is a collection of key-value pairs. In this case, the keys are strings and the values are dynamic (can be of any type).
  // Why: Converting to a map is an intermediate step that makes it easier to serialize
  // the object to formates like Json for storage or transmission.

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'FullName': fullname,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'password': password,
      'token': token,
    };
  }

  // Serialization: Convert a Map to a JSON String.
  // This method directly converts the map to a JSON string using the jsonEncode function.

  // The json.encode function is a part of the dart:convert library and is used to convert Dart objects into JSON strings.
  // It takes a Dart object (like a Map or List) and converts it into a JSON string representation.
  // This is useful for sending data over the network or saving it in a file
  String toJson() => jsonEncode(toMap());

  // Deserialization: Convert a Map to a Buyer object.
  // Purpose - Manipulation and user : Once a data is converted to a Buyer object
  // It can be easily manipulated and use within the application. For example,
  // We might want to display the user's name or email, etc in the UI, or we might want to
  // want to save the data locally.

  // The factory constructor is a special type of constructor in Dart that allows you to create an instance of a class using a different method than the default constructor.
  // Takes a Map (Usually obtained from a Json object)
  // and converts it into a Buyer object. If a field is not present in the map,\
  // it defaults to an empty String.

  // fromMap: This constructor take a Map<String, dynamic> and converts into a Buyer object.
  // It's usefull when you already have the data in map format

  factory Buyer.fromMap(Map<String, dynamic> map) {
    return Buyer(
      id:
          map['_id'] as String? ??
          "", // Use null-aware operator to handle null values
      fullname: map['FullName'] as String? ?? "",
      email: map['email'] as String? ?? "",
      state: map['state'] as String? ?? "",
      city: map['city'] as String? ?? "",
      locality: map['locality'] as String? ?? "",
      password: map['password'] as String? ?? "",
      token: map['token'] as String? ?? "",
    );
  }

  //fromJson: This factory constructor takes a JSON string and decodes into a Map<String, dynamic>
  // and then uses fromMap to converts it into a Buyer object.
}
