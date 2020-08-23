import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:informttrev1/information/sub_categories.dart';

class MainCategoriesPage extends StatefulWidget {
  MainCategoriesPage({this.params});

  final Map params;

  @override
  _MainCategoriesPageState createState() => _MainCategoriesPageState();
}

class _MainCategoriesPageState extends State<MainCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Main Categories',
          style: TextStyle(fontSize: 22.0),
        ),
      ),
      body: _buildBody(context),
    );
  }
}

Widget _buildBody(BuildContext context) {
  CollectionReference users = Firestore.instance.collection('main_categories');
  return StreamBuilder<QuerySnapshot>(
    stream: users.snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Something went wrong');
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return LinearProgressIndicator();
      } else if (!snapshot.hasData)
        return LinearProgressIndicator(); //shows a progress bar if no data found. Will have to edit this
      else
        return _buildList(context, snapshot.data.documents);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = MainCat.fromSnapshot(data);
  // final mainCatRecord = MainCat.fromSnapshot(data);

  return Padding(
    key: ValueKey(record.name),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        title: Text(record.name),
        //what I am going to do is add a logout but in subcategories.
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SubCategoriesPage(mainCategory: record.name)));
        },
      ),
    ),
  );
}

class MainCat {
  final String name;
  final DocumentReference reference;

  MainCat.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'];

  MainCat.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "MainCat<$name>";
}
