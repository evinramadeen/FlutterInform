import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In to InformTT'),
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            _EmailPasswordForm(),
            //This is where the user can use normal login means
            // _GoogleSignInSection(), //this would be a button the user can press to use google to sign in
            // _FacebookSignInSection(), //this would be a button the user can press to use facebook to sign in
          ],
        );
      }),
    );
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<
      FormState>(); //have to create a key to identify which form i'm referring to basically
  final TextEditingController _emailController =
      TextEditingController(); //controllers potentially make things easier to do with forms and more reliable
  final TextEditingController _passwordController = TextEditingController();

  bool
      _success; // this variable will monitor when the user has successfully signed in.
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: const Text('Sign in with Email and Password.'),
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'User Email Address'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter your Email';
              } else {
                //This is used to make sure a proper email format is entered before we even try to access firebase
                Pattern pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(value)) {
                  return 'Invalid Email format';
                }
              }
              return null;
            },
          ),
          TextFormField(
            obscureText: true,
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter a password at least six (6) characters long.';
              } else if (value.length <= 6) {
                return 'Password must be more than 6 characters long.';
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {
                if (_emailFormKey.currentState.validate()) {
                  _signInWithEmailAndPassword(); //if the form is properly fulled out, call the sign in function
                }
              },
              child: const Text('Login'),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {
                if (_emailFormKey.currentState.validate()) {
                  _jumpToRegister(); //if the user does not have an account, let him go to the register page.
                }
              },
              child: const Text('No Account? Register'),
            ),
          )
        ],
      ),
    );
  }

  void _signInWithEmailAndPassword() {}

  void _jumpToRegister() {}
}
