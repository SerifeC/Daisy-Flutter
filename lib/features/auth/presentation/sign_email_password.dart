import 'dart:async';
import 'package:daisy/core/errors/exceptions.dart';
import 'package:daisy/core/utils/platform_responsive_alertdialog.dart';
import 'package:daisy/core/utils/social_login_button.dart';
import 'package:daisy/features/auth/data/models/view_user_model.dart';
import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
enum FormType{Register,LogIn}
class SignInEmailandPasword extends StatefulWidget {
  @override
  _SignInEmailandPaswordState createState() => _SignInEmailandPaswordState();
}

class _SignInEmailandPaswordState extends State<SignInEmailandPasword> {
  String _email,_password;
  var _formType=FormType.LogIn;
  final _formKey=GlobalKey<FormState>();
  void _formSubmit() async{
    _formKey.currentState.save();
    debugPrint("e-mail"+_email);
    debugPrint("pass"+_password);
    final _userModel=Provider.of<UserModel>(context,listen: false);
    if(_formType==FormType.LogIn){
      try {
      Usr _logInUser=await _userModel.signInWithEmailandPassword(_email, _password);

      } on FirebaseAuthException catch (e) {
        print("ERROR ${e.code}");
         PlatformResponsiveAlertDialog(
          title: "Sign In ERROR",
          desciption: Exceptions.show(e.code),
          mainButtonText: 'Okay',
        ).show(context);
      }

    }else{
      try {
      Usr _registerUser=await _userModel.createSignInEmailandPassword(_email, _password);
      } on FirebaseAuthException catch (e) {
        print("ERORRR ${e.code}");
        await PlatformResponsiveAlertDialog(
          title: "User Create Error",
          desciption: Exceptions.show(e.code),
          mainButtonText: 'Okay',
        ).show(context);
      }
    }

  }
  void _change() {
    setState(() {
      _formType = _formType == FormType.LogIn ? FormType.Register : FormType.LogIn;
    });

  }

  @override
  Widget build(BuildContext context) {

    String _buttonText=_formType==FormType.LogIn?" Sign In":"Register";
    String _linkText=_formType==FormType.LogIn?"Don't You Have an Account?  Register":"Do You Have an Account?  Sign In";
    final _userModel = Provider.of<UserModel>(context);
    if(_userModel.user!=null){
      Future.delayed(Duration(microseconds: 1));
      Navigator.of(context).pop();

      //Navigator.of(context).popUntil(ModalRoute.withName("/"));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Sign In / Register"),

      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child:_userModel.state==ViewState.Idle? SingleChildScrollView(child: Form(key: _formKey,
          child: Column(children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  errorText: _userModel.emailErrorMessage != null
                      ? _userModel.emailErrorMessage
                      : null,
                  prefixIcon: Icon(Icons.mail),
              hintText: "e-mail",
              labelText: "E-mail",
              border: OutlineInputBorder()),
              onSaved: (bringemail){
                _email=bringemail;
              },),
          SizedBox(height: 8,),

          TextFormField(
              decoration: InputDecoration(
                  errorText: _userModel.passwordErrorMessage != null
                      ? _userModel.passwordErrorMessage
                      : null,
                  prefixIcon: Icon(Icons.vpn_key_sharp),
              hintText: "password",
              labelText: "Password",
              border: OutlineInputBorder()),
            onSaved: (bringpassword){
                _password=bringpassword;
            },
            ),
            SizedBox(height: 8,),
            SocialLoginButton(
              buttonText: _buttonText,
              buttonColor: Colors.purple,
              radius: 20,
              onPressed:()=>_formSubmit(),

            ),
            SizedBox(height: 10,),
            FlatButton(onPressed: ()=>_change(),
            child: Text(_linkText),)

          ],),
        )):Center(child: CircularProgressIndicator(),),
      ),
  );



}

}
