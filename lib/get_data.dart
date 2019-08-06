import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetData extends StatefulWidget {
  @override
  _GetDataState createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get data"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('cars').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new ListView(
                children: snapshot.data.documents.map((
                    DocumentSnapshot document) {
                  return new ListTile(
                    title: new Text(document['brand']),
                    subtitle: new Text(document['sold'].toString()),
                  );
                }).toList(),
              );
          }
        },
      ),
    );





//      StreamBuilder(
//        stream: Firestore.instance.collection('cars').snapshots(),
//        builder: (context, snapshot){
//          if(!snapshot.hasData) return Text("Loading data..Please Wait");
//          return Column(
//            children: <Widget>[
//              Text(snapshot.data.documents[0]['brand']),
//              Text(snapshot.data.documents[0]['sold'].toString()),
//            ],
//          );
//        },
//      ),
    //);
  }
}
