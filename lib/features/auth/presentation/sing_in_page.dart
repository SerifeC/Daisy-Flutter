import 'file:///C:/Users/serife/Desktop/Daisy-Flutter/lib/features/auth/presentation/sign_email_password.dart';
import 'package:daisy/core/utils/social_login_button.dart';
import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'file:///C:/Users/serife/Desktop/Daisy-Flutter/lib/features/auth/data/models/view_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {

  void _singInGuest(BuildContext context) async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    Usr _user= await _userModel.signInAnonymously();
    print("******User who signed +${_user.userID.toString()}*******");
  }

  void _signInWithGoogle(BuildContext context) async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    Usr _user= await _userModel.signInWithGoogle();
    print("******User who signed with googleeee +${_user.toString()}*******");
  }
  void _signInWithFacebook(BuildContext context) async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    Usr _user= await _userModel.signInWithFacebook();
    print("******User who signed with facebook +${_user.toString()}*******");
  }
  void _signInEmailandPassword(BuildContext context){


    Navigator.of(context).push(
      //if MaterialPAge route instead of CupertinoPageRoute than delete fullscreen after that right to left open okay:)
        MaterialPageRoute(//Full page dialog
          fullscreenDialog: true,
            builder:(context)=>SignInEmailandPasword()),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     /* appBar: AppBar(
        title: Text('Welcome Daisy '),
        elevation: 0,

      ),*/
      backgroundColor: Colors.grey.shade200,

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(6),
          child: Column(crossAxisAlignment:CrossAxisAlignment.stretch,

            children: [
              SizedBox(height: 20,),
              Text(
              "Sign In",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.purple),),
              SizedBox(height: 20,),



              Container(height: 150.0,

                child: SvgPicture.asset(
                  "svgs/daisy_logo.svg",

                ),
              ),
              SizedBox(height: 20,),

              SocialLoginButton(buttonColor: Colors.white,
              buttonText: "Sing In with Gmail",
              buttonIcon: Image.asset("images/gmail.png"),
              onPressed: ()=>_signInWithGoogle(context),
              radius: 10,
              textColor: Colors.black87,),
              SizedBox(height: 8,),
              SocialLoginButton(buttonColor: Color(0XFF334D92),
                buttonIcon: Image.asset("images/facebook.png"),
              buttonText: "Sing In with Facebook",
              onPressed: ()=>_signInWithFacebook(context),
              radius: 10,
              textColor: Colors.white,),
              SizedBox(height: 8,),
              SocialLoginButton(buttonText: "Sign In with E- mail and Password",buttonColor: Colors.blue,
                onPressed: ()=>_signInEmailandPassword(context),
                buttonIcon: Image.asset("images/email.png"),),
              SizedBox(height: 8,),
              SocialLoginButton(buttonText: "Guest Login",buttonColor: Colors.yellow.shade800,
                onPressed: ()=>
                  _singInGuest(context),

                buttonIcon: Image.asset("images/guest-list.png"),)

            ],
          ),
        ),
      ),
    );
  }




}

