import 'package:flutter/material.dart';
import 'package:informttrev1/user_entry/login.dart';
import 'package:informttrev1/user_entry/register.dart';
import 'package:informttrev1/services/authentication.dart';
import 'package:informttrev1/user_entry/root_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const primarySwatch = Colors.blue;
  static const appName = 'InformTT';
  static const buttonColor = Colors.blue;

  //boolean for showing if the user is logged in.
  static const userVerified = false; //monitor this

  final params = {
    'appName': appName,
    'primarySwatch': primarySwatch,
    'userVerified': userVerified,
    'buttonColor': buttonColor,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'InformTT Version 1',
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          primarySwatch: params['primarySwatch'],
        ),
        home: RootPage(
            params: params,
            auth:
                Auth()) //Starting off on the login page. At some point, will have to check if user is already logged in and go to main categories page
        );
  }
}
