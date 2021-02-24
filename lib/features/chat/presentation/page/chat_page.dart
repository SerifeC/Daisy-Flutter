import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daisy/features/auth/data/models/view_user_model.dart';
import 'package:daisy/features/chat/data/models/chat_view_model.dart';
import 'package:daisy/features/chat/domain/entities/message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _messageController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Daisy Chat"),
      ),
      body: _chatModel.state == ChatViewState.Busy
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Center(
        child: Column(
          children: <Widget>[
            _buildMessageList(),
            _buildNewMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return Consumer<ChatViewModel>(builder: (context, chatModel, child) {
      return Expanded(
        child: ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemBuilder: (context, index) {
            if (chatModel.hasMoreLoading &&
                chatModel.MessagesList.length == index) {
              return _loadingNewElementsIndicator();
            } else
              return _createChatBallon(chatModel.MessagesList[index]);
          },
          itemCount: chatModel.hasMoreLoading
              ? chatModel.MessagesList.length + 1
              : chatModel.MessagesList.length,
        ),
      );
    });
  }

  Widget _buildNewMessage() {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Container(
      padding: EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              cursorColor: Colors.blueGrey,
              style: new TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Messageınızı Yazın",
                border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.navigation,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () async {
                if (_messageController.text.trim().length > 0) {
                  Message _kaydedilecekMessage = Message(
                    fromWho: _chatModel.currentUser.userID,
                    toWho: _chatModel.chatedUser.userID,
                    isMe:true,
                    hostChat: _chatModel.currentUser.userID,
                    message: _messageController.text,
                  );

                  var result = await _chatModel.saveMessage(
                      _kaydedilecekMessage, _chatModel.currentUser);
                  if (result) {
                    _messageController.clear();
                    _scrollController.animateTo(
                      0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 10),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createChatBallon(Message currentMessage) {
    Color _cameMessageColor = Colors.blue;
    Color _gidenMessageColor = Theme.of(context).primaryColor;
    final _chatModel = Provider.of<ChatViewModel>(context);
    var _hourminuteValue = "";

    try {
      _hourminuteValue = _showHourMinute(currentMessage.date ?? Timestamp(1, 1));
    } catch (e) {
      print("There is ERROR:" + e.toString());
    }

    var _isMeMessage = currentMessage.isMe;
    if (_isMeMessage==true) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gidenMessageColor,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      currentMessage.message,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_hourminuteValue),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey.withAlpha(40),
                  backgroundImage:
                  NetworkImage(_chatModel.chatedUser.profilURL),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _cameMessageColor,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(currentMessage.message),
                  ),
                ),
                Text(_hourminuteValue),
              ],
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  String _showHourMinute(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formattedDate = _formatter.format(date.toDate());
    return _formattedDate;
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      bringOldMessages();
    }
  }

  void bringOldMessages() async {
    final _chatModel = Provider.of<ChatViewModel>(context);
    if (_isLoading == false) {
      _isLoading = true;
      await _chatModel.moreBringMessages();
      _isLoading = false;
    }
  }

  _loadingNewElementsIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
