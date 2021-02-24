import 'package:daisy/features/auth/data/models/view_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class MonthlyCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context,listen: false);
    return Scaffold(body: Center(child: Container(child: Text("CALENDAR\n"+_userModel.user.userID),)));
  }
}
