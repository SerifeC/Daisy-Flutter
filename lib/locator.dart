import 'features/auth/data/datasources/firebase_auth_services.dart';
import 'features/auth/data/datasources/firestore_db_services.dart';
import 'file:///C:/Users/serife/Desktop/Daisy-Flutter/lib/features/auth/data/repositories/auth_repository_impl.dart';
import 'file:///C:/Users/serife/Desktop/Daisy-Flutter/lib/features/auth/data/datasources/fake_autotantication.dart';
import 'package:get_it/get_it.dart';

GetIt locator=GetIt.instance;
void setupLocator(){
locator.registerLazySingleton(() => FirebaseAuthService());
locator.registerLazySingleton(() => FakeAutanticationService());
locator.registerLazySingleton(() => AuthRepository());
locator.registerLazySingleton(() => FireStoreDBServices());
}