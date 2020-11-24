import 'package:flutter/material.dart';
import '../models/user.dart';
import '../apis/user_api.dart';
import 'user_detail.dart';

class UserListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserListPageState();
}

class _UserListPageState extends State {
  List<User> userList = List<User>();
  int count = 0;

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  void _getUsers() {
    UserApi.fetchUsers().then((result) {
      setState(() {
        userList = result;
        count = result.length;
      });
    });
  }

  void _navigateToDetail(int id) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserDetailPage(id)),
    );
    if (result == true) {
      _getUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToDetail(null);
        },
        tooltip: "Add new User",
        child: new Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: _userListItems(),
      ),
    );
  }

  ListView _userListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Text(this.userList[position].lastname.substring(0,1)),
            ),
            title: Text(this.userList[position].firstname +
                " " +
                this.userList[position].lastname),
            subtitle: Text(this.userList[position].email),
            onTap: () {
              _navigateToDetail(this.userList[position].id);
            },
          ),
        );
      },
    );
  }
}