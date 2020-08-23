import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategoriesPage extends StatefulWidget {
  SubCategoriesPage({this.mainCategory});

  final String mainCategory;

  @override
  _SubCategoriesPageState createState() => _SubCategoriesPageState();
}

class _SubCategoriesPageState extends State<SubCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mainCategory + ' Sub Categories'),
      ),
      body: _buildBody(context, widget.mainCategory),
    );
  }
}

Widget _buildBody(BuildContext context, String mainCat) {
  //CollectionReference users = Firestore.instance.collection('category').where('main_category', isEqualTo: mainCat);
  return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('category')
          .where('main_category', isEqualTo: mainCat)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        } else if (!snapshot.hasData)
          return LinearProgressIndicator(); //shows a progress bar if no data found. Will have to edit this
        else
          return _buildList(context, snapshot.data.documents);
      });
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);

  return Padding(
    key: ValueKey(record.main_category),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        title: Text(record.sub_category),
        onTap: () => print(record.document),
      ),
    ),
  );
}

class Record {
  final String main_category;
  final String document;
  final String sub_category;
  final String summary;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['main_category'] != null),
        assert(map['document'] != null),
        assert(map['summary'] != null),
        assert(map['sub_category'] != null),
        main_category = map['main_category'],
        document = map['document'],
        summary = map['summary'],
        sub_category = map['sub_category'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() =>
      "Record<$main_category:$document:$summary:$sub_category>";
}
