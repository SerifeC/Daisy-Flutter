import 'package:daisy/features/auth/data/datasources/firebase_auth_services.dart';
import 'package:daisy/features/auth/data/datasources/firestore_db_services.dart';
import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'package:daisy/features/auth/domain/repositories/auth_base.dart';
import 'package:daisy/locator.dart';
import 'file:///C:/Users/serife/Desktop/Daisy-Flutter/lib/features/auth/data/datasources/fake_autotantication.dart';
import 'package:flutter/material.dart';

enum AppMode {DEBUG, RELEASE}
class AuthRepository implements AuthBase{
 FakeAutanticationService _fakeAutanticationService=locator <FakeAutanticationService>();
  FirebaseAuthService _firebaseAuthService=locator <FirebaseAuthService>();
 FireStoreDBServices _fireStoreDBServices=locator <FireStoreDBServices>();


  AppMode appMode=AppMode.RELEASE;
  @override
  Future<Usr> currentUser() async{
    if(appMode==AppMode.DEBUG){
     return await  _fakeAutanticationService.currentUser();

    }else{
      return await  _firebaseAuthService.currentUser();

    }


  }

  @override
  Future<Usr> signInAnonymously() async{

    if(appMode==AppMode.DEBUG){
      return await  _fakeAutanticationService.signInAnonymously();

    }else{
      return await  _firebaseAuthService.signInAnonymously();

    }
  }

  @override
  Future<bool> signOut() async{

    if(appMode==AppMode.DEBUG){
      return await  _fakeAutanticationService.signOut();

    }else{
      return await _firebaseAuthService.signOut();

    }
  }

  @override
  Future<Usr> signInWithGoogle() async{

    if(appMode==AppMode.DEBUG){
      return await  _fakeAutanticationService.signInWithGoogle();

    }else{

      Usr _user= await _firebaseAuthService.signInWithGoogle();
      bool _result=await _fireStoreDBServices.saveUser(_user);
      if(_result==true){
        return _user;
      }else{
        return null;
      }

    }
  }

  @override
  Future<Usr> signInWithFacebook() async{
    if(appMode==AppMode.DEBUG){
      return await  _fakeAutanticationService.signInWithFacebook();

    }
    else{

    Usr _user= await _firebaseAuthService.signInWithFacebook();
    bool _result=await _fireStoreDBServices.saveUser(_user);
    if(_result==true){
    return _user;
    }else{
    return null;
    }



    }
  }

  @override
  Future<Usr> createSignInEmailandPassword(String email, String password) async{
    if(appMode==AppMode.DEBUG){
      return await  _fakeAutanticationService.createSignInEmailandPassword(email, password);

    }else{

      Usr _user= await _firebaseAuthService.createSignInEmailandPassword(email, password);
      bool _result=await _fireStoreDBServices.saveUser(_user);
      if(_result==true){
        return _user;
      }else{
        return null;
      }

    }
  }

  @override
  Future<Usr> signInWithEmailandPassword(String email, String password) async{
    if(appMode==AppMode.DEBUG){
      return await  _fakeAutanticationService.signInWithEmailandPassword(email, password);

    }else{
      debugPrint("FirebaseAuth servisten almaya gidiyor");
      return await _firebaseAuthService.signInWithEmailandPassword(email, password);

    }
  }

}