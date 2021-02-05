
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum TabItem{Calendar,Home,Profil}
class TabItemData{
  final String title;
  final IconData icon;

  TabItemData(@required this.title,@required this.icon);
  static Map<TabItem,TabItemData> allTabs={
    TabItem.Calendar: TabItemData("Montly Track",Icons.calendar_today,),
    TabItem.Home: TabItemData("Home",Icons.home),
    TabItem.Profil: TabItemData("Profil",Icons.person),

};
}