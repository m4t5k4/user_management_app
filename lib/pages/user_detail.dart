import 'package:flutter/material.dart';
import '../models/user.dart';
import '../apis/user_api.dart';

final List<String> choices = const <String>[
  'Save User & Back',
  'Delete User',
  'Back to List'
];

class UserDetailPage extends StatefulWidget {
  final int id; // our UserDetailPage has an id-parameter which contains the id of the user to show
  UserDetailPage(this.id);

  @override
  State<StatefulWidget> createState() => _UserDetailPageState(id);
}

class _UserDetailPageState extends State {
  int id; // our UserDetailPageState has the same id-parameter
  _UserDetailPageState(this.id);

  User user; // state variable to contain the info of the user, at first there's no info (user = null)

  // we will use this page to update the user info as well, therefore we use TextEditingController's
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (id == null) {
      user = new User(firstname: "", lastname: "", email: "");
    } else {
      _getUser(id);
    }
  }

  void _getUser(int id) {
    UserApi.fetchUser(id).then((result) {
      // call the api to fetch the user data
      setState(() {
        user = result;
      });
    });
  }

  void _menuSelected(String index) async {
    switch (index) {
      case "0": // Save User & Back
        _saveUser();
        break;
      case "1": // Delete User
        _deleteUser();
        break;
      case "2": // Back to List
        Navigator.pop(context, true);
        break;
      default:
    }
  }

  void _saveUser() {
    user.firstname = firstnameController.text;
    user.lastname = lastnameController.text;
    user.email = emailController.text;

    if (user.id == null) {
      UserApi.createUser(user).then((result) {
        Navigator.pop(context, true);
      });
    } else {
      UserApi.updateUser(id, user).then((result) {
        Navigator.pop(context, true);
      });
    }
  }

  void _deleteUser() {
    UserApi.deleteUser(id).then((result) {
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User details"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _menuSelected,
            itemBuilder: (BuildContext context) {
              return choices.asMap().entries.map((entry) {
                return PopupMenuItem<String>(
                  value: entry.key.toString(),
                  child: Text(entry.value),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: _userDetails(),
      ),
    );
  }

  _userDetails() {
    if (user == null) {
      // show a ProgressIndicator as long as there's no user info
      return Center(child: CircularProgressIndicator());
    } else {
      TextStyle textStyle = Theme.of(context).textTheme.bodyText1;

      firstnameController.text = user.firstname; // show the user info using the TextEditingController's
      lastnameController.text = user.lastname;
      emailController.text = user.email;

      return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: firstnameController,
              style: textStyle,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "First Name",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            Container(
              height: 15,
            ),
            TextField(
              controller: lastnameController,
              style: textStyle,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Last Name",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            Container(
              height: 15,
            ),
            TextField(
              controller: emailController,
              style: textStyle,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}