import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Usr{
  final String userID;
  String email;
  String userName;
  String profilURL;
  DateTime createdAt;
  DateTime updatedAt;
  int level;
  Usr({@required this.userID, @required this.email}) ;
  Map<String,dynamic> toMap(){
    return {
      'userID':userID,
      'email':email,
      'userName':userName??  email.substring(0,email.indexOf('@')) + createRandomNumb(),
      'profilURL':profilURL?? 'http://www.smnway.com/assets/img/logo.png',
      'createdAt':createdAt?? FieldValue.serverTimestamp(),
      'updatedAt':updatedAt?? FieldValue.serverTimestamp(),
      'level':level?? 1,



    };
  }
  Usr.fromMap(Map<String,dynamic> map):
      userID=map['userID'],
        email=map['email'],
        userName=map['userName'],
        profilURL=map['profilURL'],
        createdAt=(map['createdAt'] as Timestamp).toDate(),
        updatedAt=(map['updatedAt'] as Timestamp).toDate(),
        level=map['level'];
  Usr.idvePicture({@required this.userID, @required this.profilURL});
  @override
  String toString() {
    return 'Usr{userID: $userID, email: $email, userName: $userName, profilURL: $profilURL, createdAt: $createdAt, updatedAt: $updatedAt, level: $level}';
  }

  String createRandomNumb(){
    int ranNum= Random().nextInt(999999);
    return ranNum.toString();

  }
}