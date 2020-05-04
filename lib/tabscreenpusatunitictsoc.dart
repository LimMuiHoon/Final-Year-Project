import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tracking_soc/issue.dart';
import 'package:tracking_soc/issuedetailpusatunitictsoc.dart';
import 'dart:convert';
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//import 'package:issue_app/newissue.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
//import 'package:issue_app/registrationscreen.dart';
import 'package:tracking_soc/pusatunitictsoc.dart';
//import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
//import 'package:tracking_soc/mainscreen.dart';
import 'SlideRightRoute.dart';
//import 'enterexit.dart';
import 'package:tracking_soc/splashscreen.dart';

double perpage = 1;

class TabScreenPusatUnitICTSOC extends StatefulWidget {
  final PusatUnitICTSOC pusatunitictsoc;

  TabScreenPusatUnitICTSOC({
    Key key,
    this.pusatunitictsoc,
  });

  @override
  _TabScreenPusatUnitICTSOCState createState() =>
      _TabScreenPusatUnitICTSOCState();
}

class _TabScreenPusatUnitICTSOCState extends State<TabScreenPusatUnitICTSOC> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  //Position _currentPosition;
  //String _currentAddress = "Searching current location...";
  List data;

  //get issueid => null;

  @override
  void initState() {
    super.initState();
    //init();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    //_getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.blue[100],
        appBar: AppBar(title: Text('YOUR ISSUE'), backgroundColor: Colors.blue),
        body: RefreshIndicator(
          key: refreshKey,
          color: Colors.blue,
          onRefresh: () async {
            await refreshList();
          },
          child: ListView.builder(
            //Step 6: Count the data
            itemCount: data == null ? 1 : data.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Image.asset(
                          "assets/images/issue.jpg",
                          fit: BoxFit.fitWidth,
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                                onTap: _onLogout,
                                child: Text(
                                  'LogOut',
                                  style: TextStyle(
                                      fontSize: 20, color: Color(0xFFFFFFFF)),
                                )),
                            Center(
                              child: Text("SOC Issue Tracking System",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 300,
                              height: 140,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.person,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text(
                                              widget.pusatunitictsoc.name
                                                      .toUpperCase() ??
                                                  "Not registered",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.info,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text("Your Position is " +
                                                widget
                                                    .pusatunitictsoc.position),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                      Container(
                        color: Colors.white,
                        child: Center(
                          child: Text("Issue Report by Staff Today",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                        ),
                      ),
                      Text("*Please loading first the page to view the issue!*",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                      Text(
                          "*Please click the picture to view the issue details!*",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                    ],
                  ),
                );
              }
              if (index == data.length && perpage > 1) {
                return Container(
                  width: 250,
                  color: Colors.white,
                  child: MaterialButton(
                    child: Text(
                      "Load More",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {},
                  ),
                );
              }
              index -= 1;
              return Padding(
                padding: EdgeInsets.all(2.0),
                child: Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () => _onIssueDetail(
                        data[index]['issueid'],
                        data[index]['issuetitle'],
                        data[index]['issueowneremail'],
                        data[index]['issueownername'],
                        data[index]['issuedesc'],
                        data[index]['issuetime'],
                        data[index]['issueimage'],
                        data[index]['issuecategory'],
                        data[index]['issuestatus'],
                        data[index]['issuetaskcomment'],
                        widget.pusatunitictsoc.position,
                        widget.pusatunitictsoc.name),
                    onLongPress: _onIssueDelete,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          "http://limmuihoon.com/trackingsoc/images/${data[index]['issueimage']}.jpg")))),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                      "Issue Title: " +
                                          data[index]['issuetitle']
                                              .toString()
                                              .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      "Issue Report by: " +
                                          data[index]['issueownername']
                                              .toString()
                                              .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  /*Text("Description: " +
                                                                      data[index]['issuedesc']),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),*/
                                  /*Text(
                                                                      "Issue Status: " +
                                                                          data[index]['issuestatus']
                                                                              .toString()
                                                                              .toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.bold)),*/
                                  Text("Issue Time: " +
                                      data[index]['issuetime']),
                                  //Text("Complaint: " +
                                  //  data[index]['issueowner']),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<String> makeRequest() async {
    String urlLoadIssue =
        "http://limmuihoon.com/trackingsoc/php/load_issue_pusatunitictsoc.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Your Report Issue");
    pr.show();
    http.post(urlLoadIssue, body: {
      "email": widget.pusatunitictsoc.email ?? "notavail",
      "position": widget.pusatunitictsoc.position ?? "notavail",
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["issue"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  /*void requestNewJob() {
                                    print(widget.staff.email);
                                    /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => NewIssue(
                                                  staff: widget.staff,
                                                ))
                                                );*/
                                  }*/

  void _onIssueDetail(
      String issueid,
      String issuetitle,
      String issueowneremail,
      String issueownername,
      String issuedes,
      String issuetime,
      String issueimage,
      String issuecategory,
      String issuestatus,
      String issuetaskcomment,
      String email,
      String name) {
    Issue issue = new Issue(
        issueid: issueid,
        issuetitle: issuetitle,
        issueowneremail: issueowneremail,
        issueownername: issueownername,
        issuedes: issuedes,
        issuetime: issuetime,
        issueimage: issueimage,
        issuecategory: issuecategory,
        issuestatus: issuestatus,
        issuetaskcomment: issuetaskcomment);
    //print(data);

    Navigator.push(
        context,
        SlideRightRoute(
            page: IssueDetailPusatUnitIctSOC(
                issue: issue, pusatunitictsoc: widget.pusatunitictsoc)));
  }

  void _onIssueDelete() {
    print("Delete");
  }

  void _onLogout() {
    print("LOGOUT");
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => SplashScreen()));
  }
}

/*class SlideMenu extends StatefulWidget {
  final Widget child;
  final List<Widget> menuItems;

  SlideMenu({this.child, this.menuItems});

  @override
  _SlideMenuState createState() => new _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = new Tween(
            begin: const Offset(0.0, 0.0), end: const Offset(-0.2, 0.0))
        .animate(new CurveTween(curve: Curves.decelerate).animate(_controller));

    return new GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          _controller.value -= data.primaryDelta / context.size.width;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity > 2500)
          _controller
              .animateTo(.0); //close menu on fast swipe in the right direction
        else if (_controller.value >= .5 ||
            data.primaryVelocity <
                -2500) // fully open if dragged a lot to left or on fast swipe to left
          _controller.animateTo(1.0);
        else // close if none of above
          _controller.animateTo(.0);
      },
      child: new Stack(
        children: <Widget>[
          new SlideTransition(position: animation, child: widget.child),
          new Positioned.fill(
            child: new LayoutBuilder(
              builder: (context, constraint) {
                return new AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return new Stack(
                      children: <Widget>[
                        new Positioned(
                          right: .0,
                          top: .0,
                          bottom: .0,
                          width: constraint.maxWidth * animation.value.dx * -1,
                          child: new Container(
                            color: Colors.black26,
                            child: new Row(
                              children: widget.menuItems.map((child) {
                                return new Expanded(
                                  child: child,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}*/
