import 'package:daisy/model/user_model.dart';
import 'package:daisy/sevices/auth_base.dart';


class FakeAutanticationService implements AuthBase{
  String userId="1234o234o35p";

  @override
  Future<Usr> currentUser() async{

    return Usr(userID: userId,email: "fake@fake.com");
  }

  @override
  Future<Usr> signInAnonymously() async{

    return await Future.delayed(Duration(seconds: 2),
            ()=>Usr(userID: userId,email:"fake@fake.com")
    );
  }

  @override
  Future<bool> signOut() {

    return Future.value(true);
  }

  @override
  Future<Usr> signInWithGoogle() {
    String userId="123Google123";
    @override
    Future<Usr> currentUser() async{

      return Usr(userID: userId,email: "fake@fake.com");
    }
  }

  @override
  Future<Usr> signInWithFacebook() {
    String userId="123Facebook123";
    @override
    Future<Usr> currentUser() async{

      return Usr(userID: userId,email: "fake@fake.com");
    }
  }

  @override
  Future<Usr> createSignInEmailandPassword(String email, String password) {
    // TODO: implement createSignInEmailandPassword
    throw UnimplementedError();
  }

  @override
  Future<Usr> signInWithEmailandPassword(String email, String password) {
    // TODO: implement signInWithEmailandPassword
    throw UnimplementedError();
  }

}

///BURDA APİSİZ kendi yazdığımızla koda devam edebiliriz