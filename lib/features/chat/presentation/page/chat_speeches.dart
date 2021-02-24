import 'package:daisy/features/auth/data/models/view_user_model.dart';
import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'package:daisy/features/chat/data/models/chat_view_model.dart';
import 'package:daisy/features/chat/domain/entities/chat_model.dart';
import 'package:daisy/features/chat/presentation/page/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
    class SpeechesPage extends StatefulWidget {
      @override
      _SpeechesPageState createState() => _SpeechesPageState();
    }

    class _SpeechesPageState extends State<SpeechesPage> {
      @override
      Widget build(BuildContext context) {
        UserModel _userModel = Provider.of<UserModel>(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(" DChats"),
          ),
          body: FutureBuilder<List<Chat>>(
            future: _userModel.getAllConversations(_userModel.user.userID),
            builder: (context, ChatList) {
              if (!ChatList.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var allChats = ChatList.data;

                if (allChats.length > 0) {
                  return RefreshIndicator(
                    onRefresh: _RefreshChatLists,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        var currentChat = allChats[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => ChatViewModel(
                                      currentUser: _userModel.user,
                                      chatedUser: Usr.idvePicture(
                                          userID: currentChat .withWho_chat,
                                          profilURL:
                                          currentChat.spokenUserProfilURL)),
                                  child: ChatPage(),
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(currentChat.last_message_sent),
                            subtitle: Text(currentChat.spokenUserName +
                                "  " +
                                currentChat.between_difference),
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey.withAlpha(40),
                              backgroundImage:
                              NetworkImage(currentChat.spokenUserProfilURL),
                            ),
                          ),
                        );
                      },
                      itemCount: allChats.length,
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: _RefreshChatLists,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.chat,
                                color: Theme.of(context).primaryColor,
                                size: 120,
                              ),
                              Text(
                                "No Chat Yet",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 36),
                              )
                            ],
                          ),
                        ),
                        height: MediaQuery.of(context).size.height - 150,
                      ),
                    ),
                  );
                }
              }
            },
          ),
        );
      }

      Future<Null> _RefreshChatLists() async {
        setState(() {});
        await Future.delayed(Duration(seconds: 1));
        return null;
      }
    }
