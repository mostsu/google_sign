import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign/register.dart';
import 'package:google_sign/reset_password.dart';
import 'home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  void initState() {
    super.initState();
    checkAuth(context); //พอเปิดมาหน้า Log in ให้เช็คก่อนเลยว่า Log in ค้างไว้อยู่รึเปล่า
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignInAccount _currentUser;
  TextEditingController _ctrlEmail = TextEditingController();
  TextEditingController _ctrlPassword = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  //-------------------------------------------------------

  Future<FirebaseUser> signIn() async {
    FirebaseUser _user = await _auth
        .signInWithEmailAndPassword(
            email: _ctrlEmail.text.trim(), password: _ctrlPassword.text.trim())
        .then((user) {
      print(user);
      checkAuth(context);
    }).catchError((error) {
      print(error.message);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(error.message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

  //-------------------------------------------------------

  //ตรวจสอบว่า ถ้าล็อคอินแล้ว ให้เปลี่ยนหน้าไปที่หน้า home โดยทันที
  Future checkAuth(BuildContext context) async {
    FirebaseUser _user = await _auth.currentUser(); //อันนี้จะถูกใช้ในกรณีที่มีการ Log in ด้วย Username, Password แบบธรรมดา
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account){  //ถ้าเปิด App มาแล้วมีการ Log in ของ Google Account ค้างไว้ มันจะทำตรงนี้
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        print("Already singed-in with Google Account");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage(_user, _currentUser)));
      }
    });
    //ถ้าเปิด App มาครั้งแรก โดยที่ยังไม่มีการ Log in ใดๆ มันจะมาทำตรงนี้ก่อน
    _googleSignIn.signInSilently(); //อันนี้จะถูกใช้ในกรณีที่มีการ Log in ด้วย Google Account
    if (_user != null) {
      print("Already singed-in with Email, Password");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage(_user, _currentUser)));
    }

  }

 /* Future checkAuthForGoogleSignin(BuildContext context) {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage(_user)));
      }
    });
    _googleSignIn.signInSilently();
  }
*/

  //-------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Log in"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
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
                buildButtonSignIn(),
                buildHorizontalLine("Don’t have an account?"),
                buildButtonRegister(),
                buildHorizontalLine("Other"),
                buildButtonForgotPassword(context),
                buildHorizontalLine("Log in with Social"),
                _loginWithGoogleButton(),
              ],
            ),
          ),
        ],
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
            controller: _ctrlEmail,
            decoration: InputDecoration.collapsed(hintText: "Email"),
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
            controller: _ctrlPassword,
            obscureText: true,
            decoration: InputDecoration.collapsed(hintText: "Password"),
            style: TextStyle(fontSize: 18)));
  }

  //-----------------------------------------

  Widget buildButtonSignIn() {
    return InkWell(
      onTap: () {
        signIn();
      },
      child: Container(
          constraints: BoxConstraints.expand(height: 50),
          child: Text("Sign in",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.green[200]),
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.all(12)),
    );
  }

//-----------------------------------------

  Widget buildHorizontalLine(String msg) {
    return Container(
        margin: EdgeInsets.only(top: 16),
        child: Row(children: <Widget>[
          Expanded(child: Divider(color: Colors.green[800])),
          Padding(
              padding: EdgeInsets.all(6),
              child: Text(msg, style: TextStyle(color: Colors.black87))),
          Expanded(child: Divider(color: Colors.green[800])),
        ]));
  }

  //-----------------------------------------

  Widget buildButtonRegister() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Register()));
      },
      child: Container(
        constraints: BoxConstraints.expand(height: 50),
        child: Text("Sign up",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.orange[200]),
        margin: EdgeInsets.only(top: 12),
        padding: EdgeInsets.all(12),
      ),
    );
  }

  //-----------------------------------------

  buildButtonForgotPassword(BuildContext context) {
    return InkWell(
        child: Container(
            constraints: BoxConstraints.expand(height: 50),
            //ทำให้ปุ่มมันยาวเต็มกรอบ
            child: Text("Forgot password",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.red[300]),
            margin: EdgeInsets.only(top: 12), //จัดระยะห่างบริเวนภายนอกของปุ่ม
            padding: EdgeInsets.all(12), //จัดข้อความให้มันอยู่ตรงกลางปุ่ม
        ),
        onTap: () {
          navigateToResetPasswordPage(context);
        });
  }

  navigateToResetPasswordPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ResetPassword()));
  }

  //-----------------------------------------

  FlatButton _loginWithGoogleButton() {
    return FlatButton.icon(
      onPressed: () {
        handleSignIn().whenComplete((){
          checkAuth(context);
        });
      },
      icon: Icon(IconData(0xea89, fontFamily: 'icomoon')),
      label: Text("Google Sign In"),
      color: Colors.red,
      textColor: Colors.white,
    );
  }


  Future<Null> handleSignIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      print("Current user = {'$_currentUser'}");
      if(_currentUser == null){
      }else{
      }
    } catch (error) {
      print("---------WTF Error--------------");
      print(error);
      print("---------WTF Error!!----------");
    }
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email'],
  );

  void signOutGoogle() async{
    await _googleSignIn.signOut();
    print("User Sign Out");
  }

//-----------------------------------------

//-----------------------------------------

} //End of class
