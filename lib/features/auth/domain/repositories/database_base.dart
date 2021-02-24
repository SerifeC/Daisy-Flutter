


import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'package:daisy/features/chat/domain/entities/chat_model.dart';
import 'package:daisy/features/chat/domain/entities/message_model.dart';

abstract class DBBase {
  Future<bool>saveUser(Usr user);
  Future<Usr>readUser(String userID);
  Future<bool>updateUserName(String UserID,String newUserName);
  Future<bool>updateProfilPhoto(String UserID,String profilPhotoURL);
  Future<List<Usr>>getAllUser();
  Future<List<Usr>> getUserwithPagination(Usr lastBringUser, int numberOfElementsToFetch);
  Future<List<Chat>> getAllConversations(String userID);
  Stream<List<Message>> getMessages(String currentUserID, String chatingUserID);
  Future<bool> saveMessage(Message willSaveMessage);
  Future<DateTime> showTime(String userID);



}