
import 'package:daisy/features/chat/data/models/all_user_view_model.dart';
import 'package:daisy/features/chat/data/models/chat_view_model.dart';
import 'package:daisy/features/chat/presentation/page/chat_page.dart';
import 'package:daisy/features/chat/presentation/page/chat_speeches.dart';
import 'package:daisy/features/chat/presentation/page/chat_users.dart';
import 'package:daisy/features/home/presentation/pages/about_us.dart';
import 'package:daisy/features/home/presentation/widgets/weekly_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(
              Icons.add_comment,
              color: Colors.purple,
              size: 34,
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                  create: (context) => AllUserViewModel(),
                  child:  ChatUsers(),
                )
                   ),
              );
            },
          ),
          SizedBox(
            height: 60,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.dehaze_rounded),
                    color: Colors.purple,
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutUs()),
                      );

                    },
                  ),
                  Row(
                    children: [
                      Text(
                        "December",
                        style: TextStyle(color: Colors.purple),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today_outlined),
                        color: Colors.purple,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                child: WeeklyCalendar(),
              ),
              Container(
                  height: 320,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Stack(children: [
                      Container(
                        child: Image.asset("images/daisy.png"),
                      ),
                      Positioned(
                        top: 130,
                        left: 110,
                        child: Text(
                          "      REGL \n 3 days later ",
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        ), //${user.userID}\n
                      )
                    ]),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
