import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_and_registration/model/user.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<User> _users = [];

  Future<List<User>> fetchUsers() async {
    var response = await http.get(Uri.parse('http://52.206.48.46/show-users'));

    List<User> users = [];

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);

      for (var jsonData in responseBody['data']) {
        users.add(User.fromJson(jsonData));
      }
    }
    return users;
  }

  @override
  void initState() {
    fetchUsers().then((value) {
      setState(() {
        _users.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("User Profiles"),
        ),
        body: ListView(
          children: _users.map((usr) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8,horizontal: 5),
                child: ListTile(
                   leading: FittedBox(
                     child: CircleAvatar(
                      child: Icon(Icons.account_circle),
                      radius: 25,),
                   ),
                  title: Text(usr.name),
                  subtitle: Text(usr.email), 
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
