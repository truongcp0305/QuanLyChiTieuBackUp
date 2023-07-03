import 'dart:convert';

class UserModel {
  String id;
  String username;
  String password;

  UserModel({required this.id, required this.username, required this.password});

  UserModel parseUser(String responseBody) {
    final parsed = json.decode(responseBody);
    return UserModel(
      id: parsed['id'],
      username: parsed['name'],
      password: parsed['email'],
    );
  }
}