import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'package:daisy/features/auth/domain/repositories/auth_base.dart';
import 'package:daisy/locator.dart';
import 'file:///C:/Users/serife/Desktop/Daisy-Flutter/lib/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter/material.dart';

//isteklerimizi repositorye yolladığım sayfa
enum ViewState {Idle,Busy}
class UserModel with ChangeNotifier implements AuthBase{
  ViewState _state=ViewState.Idle;//empty
  String emailErrorMessage;
  String passwordErrorMessage;
  AuthRepository _userRepository=locator<AuthRepository>();
  Usr _user;

  Usr get user => _user;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;//o anki kullanıcı verisi
    notifyListeners();
  }
UserModel(){currentUser();}
  @override
  Future<Usr> currentUser() async{
    try{
      state=ViewState.Busy;
      _user= await _userRepository.currentUser();
      return _user;


    }catch(e){
      debugPrint("VİEW MODEL CurrentUser ERROR $e");
      return null;

    }finally{
      state=ViewState.Idle;
    }
  }

  @override
  Future<Usr> signInAnonymously() async{
    try{
      state=ViewState.Busy;
      _user= await _userRepository.signInAnonymously();
      return _user;


    }catch(e){
      debugPrint("VİEW MODEL SingINAnnonimlys ERROR $e");
      return null;

    }finally{
      state=ViewState.Idle;
    }
  }


  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _user = null;
      return sonuc;
    } catch (e) {
      debugPrint("Viewmodeldeki current user error:" + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Usr> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      if (_user != null){
        print("nuulll");
        return _user;}
      else
        return null;
    } catch (e) {
      debugPrint("Viewmodel current user error:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Usr> signInWithFacebook() async{
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithFacebook();
      if (_user != null){

        return _user;}
      else
        return null;
    } catch (e) {
      debugPrint("Viewmodel face current user error:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Usr> createSignInEmailandPassword(String email, String password) async{

    if (_emailPasswordCheck(email, password)) {
    try {
    state = ViewState.Busy;
    _user =
    await _userRepository.createSignInEmailandPassword(email, password);

    return _user;
    } finally {
    state = ViewState.Idle;
    }
    } else
    return null;
    }




  @override
  Future<Usr> signInWithEmailandPassword(String email, String password) async{
    try {
      if (_emailPasswordCheck(email, password)) {
        state = ViewState.Busy;
        _user = await _userRepository.signInWithEmailandPassword(email, password);
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }
  bool _emailPasswordCheck(String email, String password) {
    var result = true;

    if (password.length < 6) {
      passwordErrorMessage = "At Least 6 caracter should be";
      result = false;
    } else
      passwordErrorMessage = null;
    if (!email.contains('@')) {
      emailErrorMessage = "Invalid email adress";
      result = false;
    } else
      emailErrorMessage = null;
    return result;
  }


}


