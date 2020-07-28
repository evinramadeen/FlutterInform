import 'package:flutter/material.dart';
import 'package:informttrev1/services/authentication.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.params, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final Map params; //this is passed in data
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isEmailVerified = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _checkEmailVerification().whenComplete(() {
      if (!_isEmailVerified && !widget.params['homePageUnverified']) {
        //sign out if email is not verified and the parameter is set to not show the page to unverified users
        _signOut();
      }
    });
  }

  Future<void> _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog(); //if email not verified, let them know they need to verify before proceeding
      _signOut(); //this makes sure the user cannot sign in if the email is not verified.
    }
  }

  void _resendVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog(); //resend verification email.
  }

  void _showVerifyEmailDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //need to return an object of type dialog
          return AlertDialog(
            title: Text('Verify your account.'),
            content: Text(
                'Please verify your account by clicking on the link sent to your email address then sign in.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Resend verification email'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _resendVerifyEmail();
                },
              ),
              FlatButton(
                child: Text('Dismiss'),
                onPressed: () {
                  Navigator.of(context).pop(); //back up to the previous screen
                },
              )
            ],
          );
        }
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Verify your account"),
            content: Text(
                "Please verify your account by clicking on the link sent to your email address."),
            actions: <Widget>[
              FlatButton(
                child: Text("Dismiss"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _mainScreen() {
    //will put my list of main categories around here.
    return Center(
      child: Text(
        "Welcome to the main Screen",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.params[
          'appName'], //by doing it like this, i just need to change the app name one place.
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Logout',
                  style: TextStyle(fontSize: 17.0, color: Colors.black)),
              onPressed: _signOut //add the logout functionality here
          )
        ],
      ),
      body: _mainScreen(),
    );
  }
}
