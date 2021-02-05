import 'package:daisy/viewmodel/view_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    return Scaffold(body: SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: <Widget>[
          SizedBox(height: 60,),
           SvgPicture.asset("svgs/daisy_logo.svg"),
          Row(mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(icon: Icon(Icons.close),color: Colors.purple,iconSize: 24,onPressed: (){
                _exit(context);
              },),
              SizedBox(width: 40,)
            ],
          ),
          Container(child: Text("Hİ\n"+_userModel.user.userID),),
        ],
      ),
    ));
  }
  Future<bool> _exit(BuildContext context) async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    bool reslt = await _userModel.signOut();

    return reslt;
  }
}
