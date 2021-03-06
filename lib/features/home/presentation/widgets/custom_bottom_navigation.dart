
import 'package:daisy/features/home/presentation/widgets/tab_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CustomBottomNavigation extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem,Widget> createrPage;
  final Map<TabItem,GlobalKey<NavigatorState>> navigatorKeys;
  const CustomBottomNavigation({Key key, @required this.currentTab,@required this.onSelectedTab,@required this.createrPage,@required this.navigatorKeys}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar:CupertinoTabBar(
      items: [
        _navItemCreate(TabItem.Calendar),
        _navItemCreate(TabItem.Home),
        _navItemCreate(TabItem.Profil),
      ],
      onTap:(index)=> onSelectedTab(TabItem.values[index]),

    ) ,
    tabBuilder:(context,index){
      final willShowItem=TabItem.values[index];
      return CupertinoTabView(
        navigatorKey: navigatorKeys[willShowItem],
        builder: (context){
          return createrPage[willShowItem];
      });
    } );
  }
  BottomNavigationBarItem _navItemCreate(TabItem tabItem) {
    final willcurrentTab=TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(willcurrentTab.icon,),
      title: Text(willcurrentTab.title)



    );
  }
}
