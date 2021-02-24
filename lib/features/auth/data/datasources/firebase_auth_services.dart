import 'dart:io';

import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'package:daisy/features/auth/domain/repositories/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';



class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Usr> currentUser()  async{
    try {
      User user =  _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print("ERROR CURRENT USER" + e.toString());
      return null;
    }
  }

  Usr _userFromFirebase(User user) {
    if (user == null) {
      return null;
    } else {
      return Usr(userID: user.uid, email: user.email);
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final _facebookLogin = FacebookLogin();
      await _facebookLogin.logOut();

      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();

      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("sign out error:" + e.toString());
      return false;
    }
  }

  @override
  Future<Usr> signInAnonymously() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(result.user);
    } catch (e) {
      print("anonim giris error:" + e.toString());
      return null;
    }
  }

  @override
  Future<Usr> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential result = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User _user = result.user;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<Usr> signInWithFacebook() async {
    final _facebookLogin = FacebookLogin();

    FacebookLoginResult _faceResult = await _facebookLogin
        .logIn(['public_profile', 'email']);

    switch (_faceResult.status) {
      case FacebookLoginStatus.loggedIn:
        if (_faceResult.accessToken != null &&
            _faceResult.accessToken.isValid()) {

          var _firebaseResult = await _firebaseAuth.signInWithCredential(FacebookAuthProvider.credential(_faceResult.accessToken.token));
          //
          // FacebookAuthCredential _firebaseResult = await _firebaseAuth.signInWithCredential(
          //     FacebookAuthProvider.credential(
          //         accessToken: _faceResult.accessToken.token));

          User _user = _firebaseResult.user;
          return _userFromFirebase(_user);
        } else {
          /* print("access token valid :" +
              _faceResult.accessToken.isValid().toString());*/
        }

        break;

      case FacebookLoginStatus.cancelledByUser:
        print("user cancel facebook login");
        break;

      case FacebookLoginStatus.error:
        print("error ! :" + _faceResult.errorMessage);
        break;
    }

    return null;
  }

  @override
  Future<Usr> createSignInEmailandPassword(
      String email, String pasword) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: pasword);
    return _userFromFirebase(result.user);
  }

  @override
  Future<Usr> signInWithEmailandPassword(String email, String pasword) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: pasword);
    return _userFromFirebase(result.user);
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) {
    // TODO: implement updateUserName
    throw UnimplementedError();
  }

  @override
  Future<String> uploadFile(String userID, String fileType, File profilPhoto) {
    // TODO: implement uploadFile
    throw UnimplementedError();
  }



}