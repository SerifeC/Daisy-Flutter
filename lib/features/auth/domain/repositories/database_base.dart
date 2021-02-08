


import 'package:daisy/features/auth/domain/entities/user_model.dart';

abstract class DBBase {
  Future<bool>saveUser(Usr user);

}