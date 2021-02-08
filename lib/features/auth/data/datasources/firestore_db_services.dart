import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'package:daisy/features/auth/domain/repositories/database_base.dart';


class FireStoreDBServices implements DBBase{
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;
  @override
  Future<bool> saveUser(Usr user) async{

   await _firebaseDB.collection("users").doc(user.userID).set(user.toMap());
   DocumentSnapshot _readUser=await _firebaseDB.doc("users/${user.userID}").get();
   Map _readUserKnowledgeMap= _readUser.data();
   Usr _readUserKnowledgeObject=Usr.fromMap(_readUserKnowledgeMap);
   print("read user object :"+_readUserKnowledgeObject.toString());


   return true;// should me map so create in model
  }
}