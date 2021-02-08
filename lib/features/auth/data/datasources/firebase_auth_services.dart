import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'package:daisy/features/auth/domain/repositories/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';


class FirebaseAuthService implements AuthBase{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  @override
  Future<Usr> currentUser() async{
  try{
    User user= await _firebaseAuth.currentUser;
    return _userfromFirebase(user);
  }
  catch(e){
    debugPrint("ERROR CURRENT USER "+ e.toString());
    return null;

  }
  }
  Usr _userfromFirebase(User user){
    if(user==null) {
      return null;
    }
    return Usr(userID: user.uid,email: user.email);

  }

  @override
  Future<Usr> signInAnonymously() async {
try{
  UserCredential result= await FirebaseAuth.instance.signInAnonymously();
  return _userfromFirebase(result.user);// dont directly user first change firebase
}catch(e){
  debugPrint("ERROR GUEST SIGN" +e.toString());
  return null;
}
  }

  @override
  Future<bool> signOut() async{

  try{
    await _firebaseAuth.signOut();
    final _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    return true;
  }catch(e){
    debugPrint("ERROR SIGNOUT" +e.toString());
    return false;
  }


  }

  @override
  Future<Usr> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      print("*****GOggle user null değil");
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential sonuc = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User _user = sonuc.user;
        return _userfromFirebase(_user);
      } else {
        print("google user bilgileri alamadı sadece aslında var ");
        return null;
      }
    } else {
      print("google user nulll");
      return null;

    }
  }

  @override
  Future<Usr> signInWithFacebook() async{
    final _facebookLogin=FacebookLogin();
    FacebookLoginResult _faceresult=await _facebookLogin.logIn(['public_profile','email']);
    switch(_faceresult.status){
      case FacebookLoginStatus.loggedIn:
        if(_faceresult.accessToken != null){
          UserCredential _firebaseresult= await  _firebaseAuth.signInWithCredential(
              FacebookAuthProvider.credential(_faceresult.accessToken.token));
          User _user = _firebaseresult.user;
          return _userfromFirebase(_user);
        }
      break;
      case FacebookLoginStatus.cancelledByUser:
        print("User Cancelled");
      break;
      case FacebookLoginStatus.error:
        print("ERROR:"+_faceresult.errorMessage);
        break;
    }
  }

  @override
  Future<Usr> createSignInEmailandPassword(String email, String password) async{
    try{
      UserCredential result= await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return _userfromFirebase(result.user);// dont directly user first change firebase
    }catch(e){
      debugPrint("ERROR  CREATE EMAİL and PASSWORD" +e.toString());
      return null;
    }

  }

  @override
  Future<Usr> signInWithEmailandPassword(String email, String password) async{
    try{
      UserCredential result= await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return _userfromFirebase(result.user);// dont directly user first change firebase
    }catch(e){
      debugPrint("ERROR EMAİL and PASSWORD" +e.toString());
      return null;
    }

  }

}