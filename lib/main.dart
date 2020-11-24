import 'package:flutter/material.dart';
import 'package:user_management_app/pages/user_list.dart';

void main() => runApp(new UserManagementApp());

class UserManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: UserListPage(),
    );
  }
}