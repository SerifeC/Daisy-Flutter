

import 'package:flutter/material.dart';
class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double buttonHeight;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  const SocialLoginButton({Key key,
    @required this.buttonText,
    this.buttonColor:Colors.grey,
    this.textColor:Colors.white,
    this.radius:10,
    this.buttonHeight:50,
    this.buttonIcon,
    this.onPressed}) : assert(buttonText!= null), super(key: key);
  @override
  Widget build(BuildContext context) {
    return             RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius))
      ),
      onPressed: onPressed,
      color:buttonColor,
      child: Row(    mainAxisAlignment: MainAxisAlignment.spaceBetween,   children: <Widget>[Container(height:50,width: 50,child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buttonIcon,
      )),

          Text(buttonText,style: TextStyle(color:textColor),),
        Opacity(opacity: 0,child: Container(height:20,width: 20))
        ],
      ),


    );

  }
}
