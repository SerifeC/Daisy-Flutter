import 'package:daisy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'package:daisy/locator.dart';
import 'package:flutter/material.dart';

enum AllUserViewState { Idle, Loaded, Busy }
class AllUserViewModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  List<Usr> _allUsers;
  Usr _lastBringUser;
  static final postsPerPage = 30;
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  AuthRepository _userRepository = locator<AuthRepository>();
  List<Usr> get userLists => _allUsers;

  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserViewModel() {
    _allUsers = [];
    _lastBringUser = null;
    getUserWithPagination(_lastBringUser, false);
  }

  getUserWithPagination(
      Usr lastBringUser, bool bringingNewElements) async {
    if (_allUsers.length > 0) {
      _lastBringUser = _allUsers.last;
      print("last bring username:" + _lastBringUser.userName);
    }

    if (bringingNewElements) {
    } else {
      state = AllUserViewState.Busy;
    }

    var newList = await _userRepository.getUserwithPagination(
        _lastBringUser, postsPerPage);

    if (newList.length < postsPerPage) {
      _hasMore = false;
    }


    _allUsers.addAll(newList);

    state = AllUserViewState.Loaded;
  }

  Future<void> dahaFazlaUserGetir() async {

    if (_hasMore) getUserWithPagination(_lastBringUser, true);

    await Future.delayed(Duration(seconds: 2));
  }

  Future<Null> refresh() async {
    _hasMore = true;
    _lastBringUser = null;
    _allUsers = [];
    getUserWithPagination(_lastBringUser, true);
  }
}