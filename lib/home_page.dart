import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser _user;
  final GoogleSignInAccount _currentUser;

  HomePage(this._user, this._currentUser, {Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email'],
  );

  void signOutGoogle() async{
    await _googleSignIn.signOut();
    print("Google Sign Out");
  }

  void signOut(BuildContext context) {
    signOutGoogle();
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        ModalRoute.withName('/'));
  }

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
                Icons.exit_to_app,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () {
                signOut(context);
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('cars').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading...');
              default:
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
                                  padding:
                                  EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 200.0,
                                              child: Image.network(
                                                '${mypost['image']}',
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '${mypost['brand']}',
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '${mypost['sold']}',
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
