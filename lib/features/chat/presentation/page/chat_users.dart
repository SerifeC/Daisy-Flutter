import 'package:daisy/features/auth/data/models/view_user_model.dart';
import 'package:daisy/features/chat/data/models/all_user_view_model.dart';
import 'package:daisy/features/chat/data/models/chat_view_model.dart';
import 'package:daisy/features/chat/presentation/page/chat_page.dart';
import 'package:daisy/features/chat/presentation/page/chat_speeches.dart';
import 'package:daisy/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatUsers extends StatefulWidget {
  @override
  _ChatUsersState createState() => _ChatUsersState();
}
 
class _ChatUsersState extends State<ChatUsers> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listScrollListener);
  }
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context,listen: false);

    _userModel.getAllUsers();
    return Scaffold(
      appBar:AppBar(title:Text("CHAT with OTHERS")

      ),
      body:  Consumer<AllUserViewModel>(
          builder: ( context, model, child) {
            if (model.state == AllUserViewState.Busy) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (model.state == AllUserViewState.Loaded) {
              return RefreshIndicator(
                onRefresh: model.refresh,
                child: ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (model.userLists.length == 1) {
                      return _noUserUi();
                    } else if (model.hasMoreLoading &&
                        index == model.userLists.length) {
                      return _addingNewElementsIndicator();
                    } else {
                      return _createUserElementList(index);
                    }
                  },
                  itemCount: model.hasMoreLoading
                      ? model.userLists.length + 1
                      : model.userLists.length,
                ),
              );
            } else {
              return Container();
            }
          },
        ),

    );
  }

  Widget _noUserUi() {
    final _usersModel = Provider.of<AllUserViewModel>(context);
    return RefreshIndicator(
      onRefresh: _usersModel.refresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.supervised_user_circle,
                  color: Theme.of(context).primaryColor,
                  size: 120,
                ),
                Text(
                  "No Users Yet",
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

  Widget _createUserElementList(int index) {
    final _userModel = Provider.of<UserModel>(context);
    final _allUsersViewModel = Provider.of<AllUserViewModel>(context);
    var _currentUser = _allUsersViewModel.userLists[index];

    if (_currentUser.userID == _userModel.user.userID) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => ChatViewModel(
                  currentUser: _userModel.user, chatedUser: _currentUser),
              child: ChatPage(),
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(_currentUser.userName),
          subtitle: Text(_currentUser.email),
          leading: CircleAvatar(
            backgroundColor: Colors.grey.withAlpha(40),
            backgroundImage: NetworkImage(_currentUser.profilURL),
          ),
        ),
      ),
    );
  }

  _addingNewElementsIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void bringMoreUsers() async {
    if (_isLoading == false) {
      _isLoading = true;
      final _allUsersViewModel = Provider.of<AllUserViewModel>(context);
      await _allUsersViewModel.dahaFazlaUserGetir();
      _isLoading = false;
    }
  }

  void _listScrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("Bottom the List");
      bringMoreUsers();
    }
  }
}