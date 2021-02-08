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
  Usr({@required this.userID, @required this.email});
  Map<String,dynamic> toMap(){
    return {
      'userID':userID,
      'email':email,
      'userName':userName?? '',
      'profilURL':profilURL?? '',
      'createdAt':createdAt?? FieldValue.serverTimestamp(),
      'updatedAt':updatedAt?? FieldValue.serverTimestamp(),
      'level':level?? 1,



    };
  }
  Usr.fromMap(Map<String,dynamic> map):
      userID=map['userID'],
        email=map['email'],
        userName=map['userNAme'],
        profilURL=map['profilURL'],
        createdAt=(map['createdAt'] as Timestamp).toDate(),
        updatedAt=(map['updatedAt'] as Timestamp).toDate(),
        level=map['level'];

  @override
  String toString() {
    return 'Usr{userID: $userID, email: $email, userName: $userName, profilURL: $profilURL, createdAt: $createdAt, updatedAt: $updatedAt, level: $level}';
  }
}