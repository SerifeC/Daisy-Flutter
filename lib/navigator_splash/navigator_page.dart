import 'file:///C:/Users/serife/Desktop/Daisy-Flutter/lib/features/auth/presentation/sing_in_page.dart';
import 'file:///C:/Users/serife/Desktop/Daisy-Flutter/lib/features/auth/data/models/view_user_model.dart';
import 'package:daisy/navigator_splash/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
/*enum PageToNavigate { Auth, Register, Home }
var  _pageToNavigate;
class NavigationController {
  final BuildContext context;
  NavigationController({@required this.context});

  init() async {
    navigateToPage(context);
    final _userModel = Provider.of<UserModel>(context,listen: false);



    if(_userModel.state==ViewState.Idle){
      if(_userModel.user==null){
        return _pageToNavigate=PageToNavigate.Auth;//SignInPage();

      }else{
        return _pageToNavigate= PageToNavigate.Home;//HomePage(user: _userModel.user,);
      }

    }else{
      return Scaffold(body:Center(child:CircularProgressIndicator() ,));
    }

  }

}
navigateToPage(con) {
  final _userModel = Provider.of<UserModel>(con,listen: false);
  if (_pageToNavigate== PageToNavigate.Auth) {
    Navigator.of(con).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>SignInPage(),
      ),
    );
  }  else if (_pageToNavigate == PageToNavigate.Home) {
    Navigator.of(con).pushReplacement(
      MaterialPageRoute(
        builder: (con) => HomePage(user: _userModel.user,),
      ),
    );
  }
}*/
class NavigatorPage extends StatefulWidget {

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);


    if(_userModel.state==ViewState.Idle){
      if(_userModel.user==null){
        return SignInPage();

      }else{
        return MainBottomPage(user: _userModel.user,);
      }

    }else{
      return Scaffold(body:Center(child:CircularProgressIndicator() ,));
    }


  }
}
