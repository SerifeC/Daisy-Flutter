import 'package:daisy/core/services/sent_notification_services.dart';
import 'package:daisy/features/auth/data/datasources/fake_autotantication.dart';
import 'package:daisy/features/auth/data/models/view_user_model.dart';
import 'package:daisy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:daisy/features/chat/data/models/all_user_view_model.dart';
import 'features/auth/data/datasources/firebase_auth_services.dart';
import 'features/auth/data/datasources/firebase_storage_services.dart';
import 'features/auth/data/datasources/firestore_db_services.dart';
import 'package:get_it/get_it.dart';

GetIt locator=GetIt.instance;
void setupLocator(){
locator.registerLazySingleton(() => FirebaseAuthService());
locator.registerLazySingleton(() => FakeAutanticationService());
locator.registerLazySingleton(() => AuthRepository());
locator.registerLazySingleton(() => FireStoreDBServices());
locator.registerLazySingleton(() => FirebaseStorageService());
locator.registerLazySingleton(() => UserModel());
locator.registerLazySingleton(() => SentNotificationServices());
locator.registerLazySingleton(() => AllUserViewModel());
}