import 'dart:io';
import 'package:daisy/features/auth/domain/entities/user_model.dart';
abstract class AuthBase{
  Future<Usr> currentUser();
  Future<Usr> signInAnonymously();
  Future<bool> signOut();
  Future<Usr> signInWithGoogle();
  Future<Usr> signInWithFacebook();
  Future<Usr> signInWithEmailandPassword(String email,String password);
  Future<Usr> createSignInEmailandPassword(String email,String password);
  Future<bool>updateUserName(String userID, String newUserName);
  Future<String> uploadFile(String userID, String fileType, File profilPhoto);
}