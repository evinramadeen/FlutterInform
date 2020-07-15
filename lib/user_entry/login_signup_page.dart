import 'package:flutter/material.dart';
import 'package:informttrev1/services/authentication.dart';

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.params, this.auth, this.onSignedIn});

  final Map params;
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _LoginSignUpPageState();
}

enum FormMode {
  LOGIN,
  FORGOTPASSWORD,
  SIGNUP
} //this will be used to change the appearance of the form between login and forgot password. Register has its own page.

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage;

  //Initial form will be the login form.
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos; // This boolean will be important when adding IOS functionality.
  bool _isLoading; //if we are loading data from firebase

  @override
  void initState() {
    _errorMessage = ''; //No error message initially
    _isLoading = false;
    super.initState();
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPasswordEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Forgot your password"),
          content: new Text("An email has been sent to reset your password"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  void _changeFormToPasswordReset() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.FORGOTPASSWORD;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.params['appName']),
      ),
      body: Stack(
        children: <Widget>[
          _showBody(),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showBody() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPasswordInput(),
              _showLoginButton(),
              _showRegisterButton(),
              _showForgotPasswordButton(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _showErrorMessage() {
    //This widget would be called to show any errors.
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return Container(
        height: 0.0, //basically an empty space.
      );
    }
  }

//This will have my app Logo.
  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 100.0,
          child: Image.asset('graphics/information.jpg'),
        ),
      ),
    );
  }

  //The email Text Form Field
  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0),
      child: TextFormField(
        controller: _emailController,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: const InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(fontSize: 22.0),
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (String value) {
          value = value.trim();
          if (value.isEmpty) {
            return 'Please enter your Email Address';
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
    );
  } //ShowEmailInput

  Widget _showPasswordInput() {
    if (_formMode != FormMode.FORGOTPASSWORD) {
      //normal login will show the password field
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: TextFormField(
          controller: _passwordController,
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: InputDecoration(
              labelText: 'Password (Six (6) or more characters.)',
              labelStyle: TextStyle(fontSize: 17.0),
              icon: Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: (String value) {
            value = value.trim(); //removes the white spaces.
            if (value.isEmpty) {
              return 'Please enter a password at least six (6) characters long.';
            } else if (value.length <= 6) {
              return 'Password must be more than 6 characters long.';
            }
            return null;
          },
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(14.0),
        child: Text('An email will be sent allowing you to reset your password',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
      );
    }
  }

  //Now we create the button widgets
  Widget _showLoginButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          color: widget.params['buttonColor'],
          child: _textLoginButton(),
          onPressed: _validateAndSubmit,
        ),
      ),
    );
  }

/*
  Widget _showRegisterButton() {
    //route to register page.
    if (_formMode != FormMode.FORGOTPASSWORD) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        alignment: Alignment.center,
        child: RaisedButton(
          onPressed: () {
            _register();
          },
          child: const Text(
            'Create an account.',
            style: TextStyle(fontSize: 22.0),
          ),
        ),
      );
    } else {
      return FlatButton(
        child: _textSecondaryButton(),
        onPressed: _changeFormToLogin,
      );
    }
  }
*/
  Widget _showRegisterButton() {
    return new FlatButton(
      child: _textSecondaryButton(),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showForgotPasswordButton() {
    return FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text('Forgot password?',
              //if in login mode, then show reset password button
              style: new TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300))
          : new Text('',
              style:
                  new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300)),
      onPressed: _changeFormToPasswordReset,
    );
  }

  Widget _textLoginButton() {
    switch (_formMode) {
      case FormMode.LOGIN:
        return new Text('Login',
            style: new TextStyle(fontSize: 26.0, color: Colors.white));
        break;
      case FormMode.SIGNUP:
        return new Text('Create account',
            style: new TextStyle(fontSize: 20.0, color: Colors.white));
        break;
      case FormMode.FORGOTPASSWORD:
        return new Text('Reset password',
            style: new TextStyle(fontSize: 20.0, color: Colors.white));
        break;
    }
    return Spacer();
  }

  Widget _textSecondaryButton() {
    switch (_formMode) {
      case FormMode.LOGIN:
        return Text('Create an account',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600));
        break;
      case FormMode.SIGNUP:
        return new Text('Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300));
        break;
      case FormMode.FORGOTPASSWORD:
        return new Text('Cancel Password Reset Request.',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic));
        break;
    }
    return Spacer();
  }

  void _register() {}

  void _login() {}

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

// Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(
              _emailController.text, _passwordController.text);
        } else if (_formMode == FormMode.SIGNUP) {
          userId = await widget.auth.signUp(
              _emailController.text, _passwordController.text);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
        } else {
          widget.auth.sendPasswordReset(_emailController.text);
          _showPasswordEmailSentDialog();
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 &&
            userId != null &&
            _formMode == FormMode.LOGIN) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _isIos ? _errorMessage = e.details : _errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
} //_LoginSignUpPageState


