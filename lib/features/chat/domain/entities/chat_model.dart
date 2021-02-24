import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chat_host;
  final String withWho_chat;
  final bool seen;
  final Timestamp creation_date;
  final String last_message_sent;
  final Timestamp seen_date;
  String spokenUserName;
  String spokenUserProfilURL;
  DateTime last_read_time;
  String between_difference;

  Chat(
      {this.chat_host,
        this.withWho_chat,
        this.seen,
        this.creation_date,
        this.last_message_sent,
        this.seen_date});

  Map<String, dynamic> toMap() {
    return {
      'chat_host': chat_host,
      'withWho_chat': withWho_chat,
      'seen': seen,
      'creation_date': creation_date ?? FieldValue.serverTimestamp(),
      'last_message_sent': last_message_sent ?? FieldValue.serverTimestamp(),
      'seen_date': seen_date,
    };
  }

  Chat.fromMap(Map<String, dynamic> map)
      : chat_host = map['chat_host'],
        withWho_chat = map['withWho_chat'],
        seen = map['seen'],
        creation_date = map['creation_date'],
        last_message_sent = map['last_message_sent'],
        seen_date = map['seen_date'];

  @override
  String toString() {
    return 'Chat{chat_host: $chat_host, withWho_chat: $withWho_chat, seen: $seen, creation_date: $creation_date, last_message_sent: $last_message_sent, seen_date: $seen_date}';
  }
}