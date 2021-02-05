

import 'package:daisy/model/user_model.dart';

abstract class AuthBase{
  Future<Usr> currentUser();
  Future<Usr> signInAnonymously();
  Future<bool> signOut();
  Future<Usr> signInWithGoogle();
  Future<Usr> signInWithFacebook();
  Future<Usr> signInWithEmailandPassword(String email,String password);
  Future<Usr> createSignInEmailandPassword(String email,String password);
}