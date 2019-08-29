import 'package:flutter/foundation.dart';

class UserProfile with ChangeNotifier{

  String fullName,gender="male",bio;

  UserProfile();

  UserProfile.getInstance(this.fullName,this.gender,this.bio);

  String get getFullName => fullName;

  String get getGender => gender;

  String get getBio => bio;

  set setFullName(String fn){
    fullName = fn;
    notifyListeners();
  }

  set setGender(String gen){
    gender = gen;
    notifyListeners();
  }

  set setBio(String bio){
    this.bio = bio;
    notifyListeners();
  }

  Map<String,dynamic> toMap(){
    var data = {
      'fullName':fullName,
      'gender':gender,
      'bio':bio
    };
    return data;
  }

}