import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'package:daisy/features/auth/domain/repositories/database_base.dart';
import 'package:daisy/features/chat/domain/entities/chat_model.dart';
import 'package:daisy/features/chat/domain/entities/message_model.dart';


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

  @override
  Future<Usr> readUser(String userID) async{
    DocumentSnapshot _readenUser=await _firebaseDB.collection("users").doc(userID).get();
    Map<String, dynamic>  _readenUserMap = _readenUser.data();
    Usr readenUserObject = Usr.fromMap(_readenUserMap);
    print("READEN USER OBJECT : " + readenUserObject.toString());
    return readenUserObject;

  }
  @override
  Future<bool> updateUserName(String userID, String newUserName) async {
    var users = await _firebaseDB.collection("users").where("userName", isEqualTo: newUserName).get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firebaseDB.collection("users").doc(userID).update({'userName': newUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilPhoto(String userID, String profilPhotoURL) async {
    await _firebaseDB.collection("users").doc(userID).update({'profilURL': profilPhotoURL});
    return true;
  }

  @override
  Future<List<Usr>> getAllUser() async{
    QuerySnapshot querySnapshot= await _firebaseDB.collection("users").get();
    List<Usr> allUsers=[];
    for(DocumentSnapshot singleUser in querySnapshot.docs){
      Usr _singleUser=Usr.fromMap(singleUser.data());
      allUsers.add(_singleUser);

    }
    allUsers=querySnapshot.docs.map((singleline)=>Usr.fromMap(singleline.data())).toList();
    return allUsers;
  }

  @override
  Future<List<Chat>> getAllConversations(String userID) {
    // TODO: implement getAllConversations
    throw UnimplementedError();
  }

  @override
  Stream<List<Message>> getMessages(String currentUserID, String chatingUserID) {
    var snapShot = _firebaseDB
        .collection("chats")
        .doc(currentUserID + "--" + chatingUserID)
        .collection("messages")
        .where("hostChat", isEqualTo: currentUserID)
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots();
    return snapShot.map((messageLists) => messageLists.docs.map((message) => Message.fromMap(message.data())).toList());
  }

  @override
  Future<List<Usr>> getUserwithPagination(Usr lastBringUser, int numberOfElementsToFetch) async {
    QuerySnapshot _querySnapshot;
    List<Usr> _allUsers = [];

    if (lastBringUser == null) {
      _querySnapshot = await FirebaseFirestore.instance.collection("users").orderBy("userName").limit(numberOfElementsToFetch).get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([lastBringUser.userName])
          .limit(numberOfElementsToFetch)
          .get();

      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Usr _tekUser = Usr.fromMap(snap.data());
      _allUsers.add(_tekUser);
    }

    return _allUsers;
  }


  @override
  Future<bool> saveMessage(Message willSaveMessage) async {
    var _messageID = _firebaseDB.collection("chats").doc().id;
    var _myDocumentID = willSaveMessage.fromWho + "--" + willSaveMessage.toWho;
    var _receiverDocumentID = willSaveMessage.toWho + "--" + willSaveMessage.fromWho;

    var _willSaveMessageMapYapisi = willSaveMessage.toMap();

    await _firebaseDB.collection("chats").doc(_myDocumentID).collection("messages").doc(_messageID).set(_willSaveMessageMapYapisi);

    await _firebaseDB.collection("chats").doc(_myDocumentID).set({
      "chat_host": willSaveMessage.fromWho,
      "withWho_chat": willSaveMessage.toWho,
      "last_message_sent": willSaveMessage.message,
      "seen": false,
      "creation_date": FieldValue.serverTimestamp(),
    });

    _willSaveMessageMapYapisi.update("isMe", (value) => false);
    _willSaveMessageMapYapisi.update("hostChat", (value) => willSaveMessage.toWho);

    await _firebaseDB.collection("chats").doc(_receiverDocumentID).collection("messages").doc(_messageID).set(_willSaveMessageMapYapisi);

    await _firebaseDB.collection("chats").doc(_receiverDocumentID).set({
      "chat_host": willSaveMessage.toWho,
      "withWho_chat": willSaveMessage.fromWho,
      "last_message_sent": willSaveMessage.message,
      "seen": false,
      "creation_date": FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<DateTime> showTime(String userID) async {
    await _firebaseDB.collection("server").doc(userID).set({
      "clock": FieldValue.serverTimestamp(),
    });

    var readenMap = await _firebaseDB.collection("server").doc(userID).get();
    Timestamp readenDate = readenMap.data()["clock"];
    return readenDate.toDate();
  }

  Future<String> tokenBring(String toWho) async {
    DocumentSnapshot _token = await _firebaseDB.doc("tokens/" + toWho).get();
    if (_token != null)
      return _token.data()["token"];
    else
      return null;
  }
  Future<List<Message>> getMessagewithPagination(String currentUserID, String chatedUserID, Message lastBringMessage, int numberOfElementsToFetch) async {
    QuerySnapshot _querySnapshot;
    List<Message> _allMessages = [];

    if (lastBringMessage == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("chats")
          .doc(currentUserID + "--" + chatedUserID)
          .collection("Messages")
          .where("hostChat", isEqualTo: currentUserID)
          .orderBy("date", descending: true)
          .limit(numberOfElementsToFetch)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("chats")
          .doc(currentUserID + "--" + chatedUserID)
          .collection("messages")
          .where("hostChat", isEqualTo: currentUserID)
          .orderBy("date", descending: true)
          .startAfter([lastBringMessage.date])
          .limit(numberOfElementsToFetch)
          .get();

      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Message _tekMessage = Message.fromMap(snap.data());
      _allMessages.add(_tekMessage);
    }

    return _allMessages;
  }
  
  
  
  
}