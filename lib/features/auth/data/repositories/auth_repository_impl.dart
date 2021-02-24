import 'dart:io';
import 'package:daisy/core/services/sent_notification_services.dart';
import 'package:daisy/features/auth/data/datasources/fake_autotantication.dart';
import 'package:daisy/features/auth/data/datasources/firebase_auth_services.dart';
import 'package:daisy/features/auth/data/datasources/firebase_storage_services.dart';
import 'package:daisy/features/auth/data/datasources/firestore_db_services.dart';
import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'package:daisy/features/auth/domain/repositories/auth_base.dart';
import 'package:daisy/features/chat/domain/entities/chat_model.dart';
import 'package:daisy/features/chat/domain/entities/message_model.dart';
import 'package:daisy/locator.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode {DEBUG, RELEASE}
class AuthRepository implements AuthBase{
 FakeAutanticationService _fakeAutanticationService=locator <FakeAutanticationService>();
  FirebaseAuthService _firebaseAuthService=locator<FirebaseAuthService>();
 FireStoreDBServices _fireStoreDBServices=locator<FireStoreDBServices>();
 FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
 SentNotificationServices _sentNotificationServices= locator<SentNotificationServices>();


  AppMode appMode=AppMode.RELEASE;
 List<Usr> allUserList = [];
 Map<String, String> userToken = Map<String, String>();
  @override
  Future<Usr> currentUser() async{
    if(appMode==AppMode.DEBUG){
     return await  _fakeAutanticationService.currentUser();

    }else{

      Usr _user = await _firebaseAuthService.currentUser();
     return  await _fireStoreDBServices.readUser(_user.userID);

    }


  }

  @override
  Future<Usr> signInAnonymously() async{

    if(appMode==AppMode.DEBUG){
      return await  _fakeAutanticationService.signInAnonymously();

    }else{
      try {
        return await _firebaseAuthService.signInAnonymously();
      }catch(e){
        debugPrint("ERROR singInAnonumlyslyRepo"+e.toString());
      }

    }
  }

  @override
  Future<bool> signOut() async{

    if(appMode==AppMode.DEBUG){
      return await  _fakeAutanticationService.signOut();

    }else{
      try {
        return await _firebaseAuthService.signOut();
      }catch(e){
        debugPrint("ERROR signOutRepo"+e.toString());
      }

    }
  }

  @override
  Future<Usr> signInWithGoogle() async{

    if(appMode==AppMode.DEBUG){
      return await  _fakeAutanticationService.signInWithGoogle();

    }else{
      try {
        Usr _user = await _firebaseAuthService.signInWithGoogle();
        bool _result = await _fireStoreDBServices.saveUser(_user);
        if (_result == true) {
          return await _fireStoreDBServices.readUser(_user.userID);
        } else {
          return null;
        }
      }catch(e){
        debugPrint("ERROR singInGooglelyRepo"+e.toString());
      }
    }
  }

  @override
  Future<Usr> signInWithFacebook() async{
    if(appMode==AppMode.DEBUG){
      return await  _fakeAutanticationService.signInWithFacebook();

    }
    else {
      try{
      Usr _user = await _firebaseAuthService.signInWithFacebook();
      bool _result = await _fireStoreDBServices.saveUser(_user);
      if (_result == true) {
        return await _fireStoreDBServices.readUser(_user.userID);
      } else {
        return null;
      }
    }catch(e){
        debugPrint("ERROR singInFacebookRepo"+e.toString());
      }


    }
  }

  @override
  Future<Usr> createSignInEmailandPassword(String email, String password) async{
    if(appMode==AppMode.DEBUG){
      return await  _fakeAutanticationService.createSignInEmailandPassword(email, password);

    }else {

      Usr _user = await _firebaseAuthService.createSignInEmailandPassword(
          email, password);
      bool _result = await _fireStoreDBServices.saveUser(_user);
      if (_result == true) {
        return await _fireStoreDBServices.readUser(_user.userID);
      } else {
        return null;
      }

    }
  }

  @override
  Future<Usr> signInWithEmailandPassword(String email, String password) async{
    if(appMode==AppMode.DEBUG){
      return await  _fakeAutanticationService.signInWithEmailandPassword(email, password);

    }else {

      debugPrint("FirebaseAuth servisten almaya gidiyor");
      Usr _user = await _firebaseAuthService.signInWithEmailandPassword(
          email, password);
      return await _fireStoreDBServices.readUser(_user.userID);


    }
  }


 Future<bool> updateUserName(String userID, String newUserName) async {
   if (appMode == AppMode.DEBUG) {
     return false;
   } else {
     return await _fireStoreDBServices.updateUserName(userID, newUserName);
   }
 }

 Future<String> uploadFile(String userID, String fileType, File profilFoto) async {
   if (appMode == AppMode.DEBUG) {
     return "dosya_indirme_linki";
   } else {
     var profilFotoURL = await _firebaseStorageService.uploadFile(userID, fileType, profilFoto);
     await _fireStoreDBServices.updateProfilPhoto(userID, profilFotoURL);
     return profilFotoURL;
   }
 }
 Future<List<Usr>> getAllUser() async{
   if (appMode == AppMode.DEBUG) {
     return [];
   } else {
     var allUserList=await _fireStoreDBServices.getAllUser();
     return  allUserList;
   }
}
 Stream<List<Message>> getMessages(String currentUserID, String sohbetEdilenUserID) {
   if (appMode == AppMode.DEBUG) {
     return Stream.empty();
   } else {
     return _fireStoreDBServices.getMessages(currentUserID, sohbetEdilenUserID);
   }
 }


 Future<bool> saveMessage(Message willSaveMessage, Usr currentUser) async {
   if (appMode == AppMode.DEBUG) {
     return true;
   } else {
     var dbWriteProceses = await _fireStoreDBServices.saveMessage(willSaveMessage);

     if (dbWriteProceses) {
       var token = "";
       if (userToken.containsKey(willSaveMessage.toWho)) {
         token = userToken[willSaveMessage.toWho];
         //print("Localden geldi:" + token);
       } else {
         token = await _fireStoreDBServices.tokenBring(willSaveMessage.toWho);
         if (token != null) userToken[willSaveMessage.toWho] = token;
         //print("Veri tabanından geldi:" + token);
       }

       if (token != null) await _sentNotificationServices
           .sentNotification(willSaveMessage, currentUser, token);

       return true;
     } else
       return false;
   }
 }

 Future<List<Chat>> getAllConversations(String userID) async {
   if (appMode == AppMode.DEBUG) {
     return [];
   } else {
     DateTime _time = await _fireStoreDBServices.showTime(userID);

     var chatList = await _fireStoreDBServices.getAllConversations(userID);

     for (var currentChat in chatList) {
       var UserinUserList = findUserInList(currentChat.withWho_chat);

       if (UserinUserList != null) {
         //print("VERILER LOCAL CACHEDEN OKUNDU");
         currentChat.spokenUserName= UserinUserList.userName;
         currentChat.spokenUserProfilURL= UserinUserList.profilURL;
       } else {
         //print("VERILER VERITABANINDAN OKUNDU");
         /*print(
              "aranılan user daha önceden veritabanından getirilmemiş, o yüzden veritabanından bu degeri okumalıyız");*/
         var _veritabanindanOkunanUser = await _fireStoreDBServices.readUser(currentChat.withWho_chat);
         currentChat.spokenUserName= _veritabanindanOkunanUser.userName;
         currentChat.spokenUserProfilURL = _veritabanindanOkunanUser.profilURL;
       }

       calculateTimeAgo(currentChat, _time);
     }

     return chatList;
   }
 }

 Usr findUserInList(String userID) {
   for (int i = 0; i < allUserList.length; i++) {
     if (allUserList[i].userID == userID) {
       return allUserList[i];
     }
   }

   return null;
 }

 void calculateTimeAgo(Chat currentChat, DateTime time) {
   currentChat.last_read_time = time;

   timeago.setLocaleMessages("tr", timeago.TrMessages());

   var _duration = time.difference(currentChat.creation_date.toDate());
   currentChat.between_difference= timeago.format(time.subtract(_duration), locale: "tr");
 }

 Future<List<Usr>> getUserwithPagination(Usr enSonGetirilenUser, int getirilecekElemanSayisi) async {
   if (appMode == AppMode.DEBUG) {
     return [];
   } else {
     List<Usr> _userList = await _fireStoreDBServices.getUserwithPagination(enSonGetirilenUser, getirilecekElemanSayisi);
     allUserList.addAll(_userList);
     return _userList;
   }
 }

 Future<List<Message>> getMessageWithPagination(String currentUserID, String sohbetEdilenUserID, Message enSonGetirilenMessage, int getirilecekElemanSayisi) async {
   if (appMode == AppMode.DEBUG) {
     return [];
   } else {
     return await _fireStoreDBServices.getMessagewithPagination(currentUserID, sohbetEdilenUserID, enSonGetirilenMessage, getirilecekElemanSayisi);
   }
 }


}