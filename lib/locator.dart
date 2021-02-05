import 'package:daisy/repository/user_repository.dart';
import 'package:daisy/sevices/fake_autotantication.dart';
import 'package:daisy/sevices/firebase_auth_services.dart';
import 'package:daisy/sevices/firestore_db_services.dart';
import 'package:get_it/get_it.dart';

GetIt locator=GetIt.instance;
void setupLocator(){
locator.registerLazySingleton(() => FirebaseAuthService());
locator.registerLazySingleton(() => FakeAutanticationService());
locator.registerLazySingleton(() => UserRepository());
locator.registerLazySingleton(() => FireStoreDBServices());
}