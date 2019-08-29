import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/ui/ProfileScreen.dart';
import 'package:provider/provider.dart';
import 'RectanglePainter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: selectHomeScreen(),
    );
  }
}

Widget selectHomeScreen() {
  return StreamBuilder(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder: (BuildContext context, AsyncSnapshot snap) {
      if (snap.connectionState == ConnectionState.waiting) {
        return Text("Loading");
      } else {
        if (snap.hasData) {
          FirebaseUser user = snap.data;
          return StreamProvider<FirebaseUser>.value(
              initialData: user,
              value: FirebaseAuth.instance.onAuthStateChanged,
              child: ProfileScreen());
        } else {
          return MyHomePage();
        }
      }
    },
  );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String username, password;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double headingHeight = height * 0.25;
    double rectHeight = height * 0.65;
    double padding = width / 10;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepOrange, Colors.orange],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          children: <Widget>[
            Container(
              width: width,
              height: headingHeight,
              child: Center(
                child: Text(
                  "Log In",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            Container(
              height: rectHeight,
              child: Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  CustomPaint(
                    painter: RectanglePainter(MediaQuery.of(context).size),
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.50,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Welcome",
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (data) {
                                  this.setState(() {
                                    username = data.toString();
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.6)),
                                        borderSide:
                                            BorderSide(color: Colors.orange))),
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (data) {
                                  this.setState(() {
                                    password = data.toString();
                                  });
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.6)),
                                        borderSide:
                                            BorderSide(color: Colors.orange))),
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () => {},
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 70, 50),
                      child: FloatingActionButton(
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.orange,
                        onPressed: () {
                          debugPrint("USERNAME :$username Password $password");
                          FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: username.trim(),
                              password: password.toString().trim());
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
