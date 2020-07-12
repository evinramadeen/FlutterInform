import 'package:flutter/material.dart';
import 'package:informttrev1/user_entry/login_signup_page.dart';
import 'login.dart';
import 'package:informttrev1/landing_page.dart';

//This page will be where it is determined if the user is already logged in and can be trasnferred to the main page automatically
//or if the user needs to get sent to the login page.
class RootPage extends StatefulWidget {
  RootPage({this.params});

  final Map params;

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  Widget _waitingScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text("InformTT"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(), //shows a loading page basically
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Show the login or home page depending on user login state
    const bool showLogin =
        true; //a place holder until i put the code to test if user is logged in

    switch (showLogin) {
      case true:
        return LoginSignUpPage(
          params: widget.params,
        );
        break;
      case false:
        return HomePage(
          //this page would be the first page when the user logs into the app. Main categories page
          params: widget.params,
        );
        break;
      default:
        return _waitingScreen();
    }
  }
}
