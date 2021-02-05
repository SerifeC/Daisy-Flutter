import 'package:daisy/locator.dart';
import 'package:daisy/splash/navigator_page.dart';
import 'package:daisy/splash/splash_screen.dart';
import 'package:daisy/viewmodel/view_user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return
      ChangeNotifierProvider(
          create: (context) => UserModel(),
          child:  MaterialApp(
            title: 'Live Chat App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.purple,
            ),
            home:
                SplashPage(),));


  }
}


