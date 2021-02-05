import 'package:daisy/app/bottomnavigation/custom_bottom_navigation.dart';
import 'package:daisy/app/home_page.dart';
import 'package:daisy/app/montly_calendar_page.dart';
import 'package:daisy/app/profil_page.dart';
import 'package:daisy/model/user_model.dart';
import 'package:daisy/viewmodel/view_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bottomnavigation/tab_items.dart';


class MainBottomPage extends StatefulWidget {
  final Usr user;
   MainBottomPage({Key key,   this.user}) : super(key: key);

  @override
  _MainBottomPageState createState() => _MainBottomPageState();
}

class _MainBottomPageState extends State<MainBottomPage> {
  TabItem _currentTab=TabItem.Home;
  Map<TabItem,Widget> allPages(){
    return{
      TabItem.Calendar:MonthlyCalendar(),
      TabItem.Home:HomePage(),
      TabItem.Profil:ProfilPage(),
    };
  }
  @override
  Widget build(BuildContext context) {


    return CustomBottomNavigation(currentTab: _currentTab,createrPage:allPages(),onSelectedTab: (choosenTab){
                setState(() {
                  _currentTab=choosenTab;
                });
                debugPrint("Choosen tab"+choosenTab.toString());
              },);




  }


}


