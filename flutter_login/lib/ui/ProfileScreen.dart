import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/Modals/UserProfile.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var fnController = TextEditingController();
    var fnBio = TextEditingController();

    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return StreamProvider<DocumentSnapshot>.value(
        value: Firestore.instance
            .collection("profiles")
            .document(user.uid)
            .snapshots(),

        child: Builder(
            builder: (context) {
          DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
          if (snapshot != null && snapshot.exists) {

            var data = snapshot.data;

            return ChangeNotifierProvider<UserProfile>(
              builder: (context) => UserProfile.getInstance(
                  data["fullName"], data["gender"], data["bio"]),
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  title: Text(
                    "Your Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                  elevation: 0.0,
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 0.0),
                      child: IconButton(
                          icon: Icon(Icons.exit_to_app, color: Colors.white),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          }),
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  child: Stack(children: <Widget>[
                    Align(
                      alignment: Alignment.bottomRight,
                      heightFactor: 0.25,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(
                              MediaQuery.of(context).size.width)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Consumer<UserProfile>(
                          builder: (context, pData, _) {
                            fnController.value =
                                TextEditingValue(text: pData.fullName);
                            fnBio.value = TextEditingValue(text: pData.bio);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 50, 0.0, 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                "https://randomuser.me/api/portraits/men/46.jpg"))),
                                    width: 150,
                                    height: 150,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextField(
                                      onChanged: (text) {
                                        pData.fullName = text.trim();
                                      },
                                      controller: fnController,
                                      decoration: InputDecoration(
                                          hintText: "Full Name",
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.6)),
                                              borderSide: BorderSide(
                                                  color: Colors.orange)))),
                                ),
                                GenderSelector(pData.gender),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextField(
                                      controller: fnBio,
                                      onChanged: (text) {
                                        pData.bio = text.trim();
                                      },
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                          hintText: "Bio",
                                          hintMaxLines: 5,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.6)),
                                              borderSide: BorderSide(
                                                  color: Colors.orange)))),
                                ),
                                MaterialButton(
                                  color: Colors.orange,
                                  onPressed: () {
                                    snapshot.reference
                                        .updateData(pData.toMap());
                                  },
                                  child: Text(
                                    "Save Profile",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }));
  }
}

class GenderSelector extends StatefulWidget {
  final String gender;

  GenderSelector(this.gender);

  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  String _gender;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gender = widget.gender;
  }

  @override
  Widget build(BuildContext context) {
    var profile = Provider.of<UserProfile>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: "male",
          activeColor: Colors.orange,
          groupValue: _gender,
          onChanged: (value) {
            profile.gender = value;
            this.setState(() {
              _gender = value;
            });
          },
        ),
        Text("Male"),
        Radio(
          value: "female",
          groupValue: _gender,
          onChanged: (value) {
            profile.gender = value;
            this.setState(() {
              _gender = value;
            });
          },
        ),
        Text("Female"),
        Radio(
          value: "other",
          groupValue: _gender,
          onChanged: (value) {
            profile.gender = value;
            this.setState(() {
              _gender = value;
            });
          },
        ),
        Text("Other"),
      ],
    );
  }
}
