import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class UserApi {
  static String url = 'https://pink-emu-13.loca.lt/';

  static Future<List<User>> fetchUsers() async {
    final response = await http.get(url + '/users');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => new User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<User> fetchUser(int id) async {
    final response = await http.get(url + '/users/' + id.toString());
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  static Future<User> createUser(User user) async {
    final http.Response response = await http.post(
      url + '/users',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );
    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  static Future<User> updateUser(int id, User user) async {
    final http.Response response = await http.put(
      url + '/users/' + id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  static Future deleteUser(int id) async {
    final http.Response response =
        await http.delete(url + '/users/' + id.toString());
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete user');
    }
  }

}