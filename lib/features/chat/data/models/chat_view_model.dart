import 'dart:async';

import 'package:daisy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'package:daisy/features/chat/domain/entities/message_model.dart';
import 'package:daisy/locator.dart';
import 'package:flutter/material.dart';


enum ChatViewState { Idle, Loaded, Busy }

class ChatViewModel with ChangeNotifier {
  List<Message> _allMessages;
  ChatViewState _state = ChatViewState.Idle;
  static final postPerPage = 30;
  AuthRepository _userRepository = locator<AuthRepository>();
  final Usr currentUser;
  final Usr chatedUser;
  Message _lastBringMessage;
  Message _addedInListMessages;
  bool _hasMore = true;
  bool _newMessageListeners  = false;

  bool get hasMoreLoading => _hasMore;

  StreamSubscription _streamSubscription;

  ChatViewModel({this.currentUser, this.chatedUser}) {
    _allMessages = [];
    getMessageWithPagination(true);
  }

  List<Message> get MessagesList => _allMessages;

  ChatViewState get state => _state;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  dispose() {
    print("Chatviewmodel disposed");
    _streamSubscription.cancel();
    super.dispose();
  }

  Future<bool> saveMessage(Message willSaveMessage, Usr currentUser) async {
    return await _userRepository.saveMessage(willSaveMessage, currentUser);
  }

  void getMessageWithPagination(bool newMessagesBringing) async {
    if (_allMessages.length > 0) {
      _lastBringMessage = _allMessages.last;
    }

    if (!newMessagesBringing) state = ChatViewState.Busy;

    var bringMessages =
    await _userRepository.getMessageWithPagination(currentUser.userID, chatedUser.userID, _lastBringMessage, postPerPage);

    if (bringMessages.length < postPerPage) {
      _hasMore = false;
    }

    /*bringMessages
        .forEach((msj) => print("getirilen Messagelar:" + msj.Message));*/

    _allMessages.addAll(bringMessages);
    if (_allMessages.length > 0) {
      _addedInListMessages = _allMessages.first;
      // print("Listeye eklenen ilk Message :" + _addedInListMessages.Message);
    }

    state = ChatViewState.Loaded;

    if (_newMessageListeners == false) {
      _newMessageListeners = true;
      //print("Listener yok o yüzden atanacak");
      assignNewMessageList();
    }
  }

  Future<void> moreBringMessages() async {
    //print("Daha fazla Message getir tetiklendi - viewmodeldeyiz -");
    if (_hasMore) getMessageWithPagination(false);
    /*else
      print("Daha fazla eleman yok o yüzden çagrılmayacak");*/
    await Future.delayed(Duration(seconds: 2));
  }

  void assignNewMessageList() {
    //print("Yeni Messagelar için listener atandı");
    _streamSubscription = _userRepository.getMessages(currentUser.userID, chatedUser.userID).listen((currentData) {
      if (currentData.isNotEmpty) {
        //print("listener tetiklendi ve son getirilen veri:" +currentData[0].toString());

        if (currentData[0].date != null) {
          if (_addedInListMessages == null) {
            _allMessages.insert(0, currentData[0]);
          } else if (_addedInListMessages.date.millisecondsSinceEpoch != currentData[0].date.millisecondsSinceEpoch) _allMessages.insert(0, currentData[0]);
        }

        state = ChatViewState.Loaded;
      }
    });
  }
}