import 'package:daisy/features/auth/domain/entities/user_model.dart';
import 'package:daisy/features/home/presentation/pages/home_page.dart';
import 'package:daisy/features/home/presentation/widgets/custom_bottom_navigation.dart';
import 'package:daisy/features/home/presentation/widgets/tab_items.dart';
import 'package:daisy/features/montlytrack/presentation/pages/montly_calendar_page.dart';
import 'package:daisy/features/profil/presentation/pages/profil_page.dart';
import 'package:flutter/material.dart';

class MainBottomPage extends StatefulWidget {
  final Usr user;
  MainBottomPage({Key key, this.user}) : super(key: key);

  @override
  _MainBottomPageState createState() => _MainBottomPageState();
}

class _MainBottomPageState extends State<MainBottomPage> {
  TabItem _currentTab = TabItem.Home;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Calendar: GlobalKey<NavigatorState>(),
    TabItem.Home: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };
  Map<TabItem, Widget> allPages() {
    return {

      TabItem.Calendar: MonthlyCalendar(),
      TabItem.Home: HomePage(),
      TabItem.Profil: ProfilPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CustomBottomNavigation(
        currentTab: _currentTab,
        navigatorKeys: navigatorKeys,
        createrPage: allPages(),
        onSelectedTab: (choosenTab) {
          if(choosenTab==_currentTab){
            navigatorKeys[choosenTab].currentState.popUntil((route) => route.isFirst);
          }else{
            setState(() {
              _currentTab = choosenTab;
            });
          }

          debugPrint("Choosen tab" + choosenTab.toString());
        },
      ),
    );
  }
}
