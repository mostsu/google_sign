import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'get_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Post App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.dehaze),
              onPressed: () {
                //
              }),
          title: Container(
            alignment: Alignment.center,
            child: Text("Tech Post", style: TextStyle()),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                size: 20,
                color: Colors.white,
              ),
              onPressed: null,
            )
          ],
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('post').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              const Text("Loading");
              print("-------------------");
              print("Motherfucker !");
              print("-------------------");
            } else {
              print("-------------------");
              print("Oh Yeahh !");
              print("-------------------");
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot mypost = snapshot.data.documents[index];
                    return Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 350,
                              child: Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Material(
                                  color: Colors.white,
                                  elevation: 14.0,
                                  shadowColor: Color(0x802196F3),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: 200.0,
                                            child: Image.network(
                                              '${mypost['image']}',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            '${mypost['title']}',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            '${mypost['subtitle']}',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .47,
                            left: MediaQuery.of(context).size.height * .52,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: CircleAvatar(
                              backgroundColor: Color(0xff543B7A),
                              child: Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            }
          },
        ));
  }
}
