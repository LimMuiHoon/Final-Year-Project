import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracking_soc/jpp.dart';
import 'package:tracking_soc/socmanagement.dart';
import 'package:tracking_soc/tabscreen.dart';
import 'package:tracking_soc/tabscreen2.dart';
import 'package:tracking_soc/tabscreen3.dart';
import 'package:tracking_soc/staff.dart';

class MainScreen extends StatefulWidget {
  final Staff staff;

  const MainScreen({Key key, this.staff, SocManagement socmanagement, JPP jpp})
      : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabScreen(staff: widget.staff),
      TabScreen2(staff: widget.staff),
      TabScreen3(staff: widget.staff),
      //TabScreen4(user: widget.user),
    ];
  }

  String $pagetitle = "SOC Issue Tracking System";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        //backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Issue"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("Add"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.person, ),
            title: Text("Profile"),
          )*/
        ],
      ),
    );
  }
}
