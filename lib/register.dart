import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _ctrlEmailRegis = TextEditingController();
  TextEditingController _ctrlPasswordRegis = TextEditingController();
  TextEditingController _ctrlConPasswordRegis = TextEditingController();

  signUp() {
    String email = _ctrlEmailRegis.text.trim();
    String password = _ctrlPasswordRegis.text.trim();
    String confirmPassword = _ctrlConPasswordRegis.text.trim();
    if (password == confirmPassword && password.length >= 6) {
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        print("Sign up user successful.");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Login()),
            ModalRoute.withName('/'));
      }).catchError((error) {
        print(error.message);
      });
    } else {
      print("Password and Confirm-password is not match.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: Colors.green[50],
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                    colors: [Colors.yellow[100], Colors.green[100]])),
            margin: EdgeInsets.all(32),
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildTextFieldEmail(),
                buildTextFieldPassword(),
                buildTextFieldPasswordConfirm(),
                buildButtonSignUp(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  //-----------------------------------------

  Container buildTextFieldEmail() {
    return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
        child: TextField(
          controller: _ctrlEmailRegis,
            decoration: InputDecoration.collapsed(hintText: "Email"),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: 18)));
  }

  //-----------------------------------------

  Container buildTextFieldPassword() {
    return Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
        child: TextField(
            controller: _ctrlPasswordRegis,
            obscureText: true,
            decoration: InputDecoration.collapsed(hintText: "Password"),
            style: TextStyle(fontSize: 18)));
  }

  //-----------------------------------------

  Container buildTextFieldPasswordConfirm() {
    return Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
        child: TextField(
            controller: _ctrlConPasswordRegis,
            obscureText: true,
            decoration: InputDecoration.collapsed(hintText: "Re-password"),
            style: TextStyle(fontSize: 18)));
  }

  //-----------------------------------------

  Widget buildButtonSignUp(BuildContext context) {
    return InkWell(
      onTap: () {
        signUp();
      },
      child: Container(
          constraints: BoxConstraints.expand(height: 50),
          child: Text("Sign up",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: Colors.green[200]),
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.all(12)
      ),
    );
  }

} //End of class
