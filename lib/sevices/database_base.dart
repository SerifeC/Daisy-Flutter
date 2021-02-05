

import 'package:daisy/model/user_model.dart';

abstract class DBBase {
  Future<bool>saveUser(Usr user);

}