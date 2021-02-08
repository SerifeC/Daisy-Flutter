import 'dart:ui';

import 'file:///C:/Users/serife/Desktop/Daisy-Flutter/lib/navigator_splash/navigator_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {



  @override
  Widget build(BuildContext context) {
    return
             Container(color: Colors.white,
               child: Padding(
                 padding: const EdgeInsets.only(top:100.0,bottom: 0),
                 child: SplashScreen(
                    useLoader: false,
                    backgroundColor: Colors.white,
                    seconds: 3,
                    image: Image.asset("images/daisy_splash.gif"),
                    photoSize: 150,
                    loadingText: Text('              DAISY \n\n   Period Tracker App ',
                      style: TextStyle(fontWeight: FontWeight.bold,color:Colors.purple.shade900,fontSize: 20),),




                    //loaderColor: Colors.white,

                    navigateAfterSeconds: NavigatorPage(),

            ),
               ),
             );
  }
}
