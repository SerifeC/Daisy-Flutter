import 'dart:io';
import 'package:daisy/core/utils/platform_responsive_alertdialog.dart';
import 'package:daisy/core/utils/social_login_button.dart';
import 'package:daisy/features/auth/data/models/view_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController _controllerUserName;
  File _profilPhoto;
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerUserName = TextEditingController();
  }
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }
  void _cameraPhoto() async {
    var _newPicture = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _profilPhoto = _newPicture;
      Navigator.of(context).pop();
    });
  }

  void _chooseGallery() async {
    var _newPicture= await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _profilPhoto = _newPicture;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    _controllerUserName.text=_userModel.user.userName ;
    //print("Profil sayfasındaki user degerleri :" + _userModel.user.toString());
    return Scaffold(
     
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height/20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment:MainAxisAlignment.end,children: [IconButton(
            icon: Icon(Icons.cancel,color: Colors.deepPurple,),iconSize: 28,onPressed: (){
                  requestConfirmationforExit(context);
                },)],),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/18,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 160,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.camera),
                                  title: Text("Take a Photo from camera"),
                                  onTap: () {
                                    _cameraPhoto();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text("Choose from Gallery"),
                                  onTap: () {
                                    _chooseGallery();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Container(
                    child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.purple.shade50,
                      backgroundImage: _profilPhoto == null ? NetworkImage(_userModel.user.profilURL) : FileImage(_profilPhoto),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/28,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _userModel.user.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Your Email",
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerUserName,
                  decoration: InputDecoration(
                    labelText: "User Name",
                    hintText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SocialLoginButton(
                  buttonColor: Colors.deepPurple,

                  buttonText: "Save Changes",
                  onPressed: () {
                    _userNameUpdate(context);
                    _profilPhotoUpdate(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _exit(BuildContext context) async{
    final _userModel = Provider.of<UserModel>(context,listen: false);
    bool reslt = await _userModel.signOut();

    return reslt;
  }

  Future requestConfirmationforExit(BuildContext context)async{
    final _result= await PlatformResponsiveAlertDialog(
      title: "Are You Sure?",
      desciption: "Are you sure you want to quit?",
      mainButtonText: "Yes",
      cancelButtonText: "Cancel",
    ).show(context);
    if(_result==true){
      _exit(context);
    }
  }

  void _userNameUpdate(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(_userModel.user.userID, _controllerUserName.text);

      if (updateResult == true) {
        PlatformResponsiveAlertDialog(
          title: "Succesful",
          desciption: "Username changed",
         mainButtonText: "Okay",
        ).show(context);
      } else {
        _controllerUserName.text=_userModel.user.userName;
        PlatformResponsiveAlertDialog(
          title: "ERROR",
          desciption: "Username is already in use",
          mainButtonText: "Okay",
        ).show(context);
      }
    }
  }

  void _profilPhotoUpdate(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_profilPhoto != null) {
      var url = await _userModel.uploadFile(_userModel.user.userID, "profil_foto", _profilPhoto);
      //print("gelen url :" + url);

      if (url != null) {
        PlatformResponsiveAlertDialog(
          title: "Succesful",
          desciption: "Username changed",
          mainButtonText: "Okay",
        ).show(context);
      }
    }
  }
}
