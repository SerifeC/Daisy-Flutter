
import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'package:daisy/features/chat/domain/entities/message_model.dart';
import 'package:http/http.dart' as http;

class SentNotificationServices {
  Future<bool> sentNotification(Message willSentNotification, Usr sentUser, String token) async {
    String endURL = "https://fcm.googleapis.com/fcm/send";
    String firebaseKey = "AIzaSyCeFhtIo3YNz4gnGJcTF5vazSke6D5u8HA";
    Map<String, String> headers = {"Content-type": "application/json", "Authorization": "key=$firebaseKey"};

    String json =
        '{ "to" : "$token", "data" : { "message" : "${willSentNotification.message}", "title": "${sentUser.userName} yeni Message", "profilURL": "${sentUser.profilURL}", "sentUserID" : "${sentUser.userID}" } }';

    http.Response response = await http.post(endURL, headers: headers, body: json);

    if (response.statusCode == 200) {
      print("PROCESS SUCCESFULL");
    } else {
      /*print("işlem basarısız:" + response.statusCode.toString());
      print("jsonumuz:" + json);*/
    }
  }
}