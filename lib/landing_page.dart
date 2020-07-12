import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.params}) : super(key: key);

  final Map params; //this is passed in data

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                style: TextStyle(fontSize: 17.0, color: Colors.green)),
            onPressed: () {
              print('Button Pressed');
            }, //add the logout functionality here
          )
        ],
      ),
      body: _mainScreen(),
    );
  }
}
