import 'package:flutter/material.dart';
import 'package:informttrev1/user_entry/login_signup_page.dart';
import 'login.dart';
import 'package:informttrev1/landing_page.dart';
import 'package:informttrev1/services/authentication.dart';

//This page will be where it is determined if the user is already logged in and can be trasnferred to the main page automatically
//or if the user needs to get sent to the login page.
class RootPage extends StatefulWidget {
  RootPage({this.params, this.auth});

  final BaseAuth auth;
  final Map params;

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String _userEmail = "";
  String _userName = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          //if a user is currently logged in
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString(); //get current user if logged in
        _userEmail = user.email.toString();
        _userName = user.displayName.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN; //make it known someone is logged in
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = ""; //clear the user ID
      _userEmail = "";
      _userName = "";
    });
  }

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

    switch (authStatus) {
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignUpPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
          params: widget.params,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return HomePage(
            userId: _userId,
            userEmail: _userEmail,
            userName: _userName,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
            params: widget.params,
          );
        } else
          return _waitingScreen();
        break;
      default:
        return _waitingScreen();
    }
  }
}
