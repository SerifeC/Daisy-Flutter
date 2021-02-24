import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String fromWho;
  final String toWho;
  final bool isMe;
  final String message;
  final Timestamp date;
  final String hostChat;
  Message(
      {this.fromWho,
        this.toWho,
        this.isMe,
        this.message,
        this.date,
        this.hostChat});
  Map<String, dynamic> toMap() {
    return {
      'fromWho': fromWho,
      'toWho': toWho,
      'isMe': isMe,
      'message': message,
      'hostChat': hostChat,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  Message.fromMap(Map<String, dynamic> map)
      : fromWho = map['fromWho'],
        toWho = map['toWho'],
        isMe = map['isMe'],
        message = map['message'],
        hostChat = map['hostChat'],
        date = map['date'];
String toString(){
  return 'Message{fromWho: $fromWho,  toWho : $toWho , isMe: $isMe, message: $message, date: $date}';
}

}