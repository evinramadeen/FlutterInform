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

//buildbody is used to create the body. at first stream builder takes the snapshot of the data in the database.
//by using stream builder, it updates the data in real time. may not actually be needed since my data will be static. will review the negatives of using it
Widget _buildBody(BuildContext context, String mainCat) {
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
          return _buildList(
              context,
              snapshot.data
                  .documents); //calls a function named build list. tried to leave the functions modular.
      });
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data))
        .toList(), // the to list statement is what turns the data into the list form basically
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
        //expansion tile allows the user to click the sub category and view a summary of which each category is about.
        child: ExpansionTile(
          title: Text(record.sub_category,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
          children: <Widget>[
            ListTile( //this is where the summary of the particular item will be.
              title: Text(record.summary),
              onTap: () => printSum(record.summary.toString()),
            )
          ],
        )
    ),
  );
}
//delete this when a proper summary is in place. can put the jump to the document in here if i dont delete it.
void printSum(String holder) {
  print(holder + ' was clicked');
}

class Record {
  //this class mimics all of the fields in the database. it allows me to reference the different fields.
  final String main_category;
  final String document; //this will have to change when i enter the html documents.
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
