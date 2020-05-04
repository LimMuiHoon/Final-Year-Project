import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tracking_soc/issue.dart';
import 'package:tracking_soc/issuedetail.dart';
import 'dart:convert';
//import 'dart:io';
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//import 'package:issue_app/newissue.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
//import 'package:issue_app/registrationscreen.dart';
import 'package:tracking_soc/socmanagement.dart';
//import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
//import 'package:tracking_soc/mainscreen.dart';
import 'SlideRightRoute.dart';
import 'newissue.dart';
import 'package:tracking_soc/splashscreen.dart';
//import 'package:tracking_soc/staff.dart';
//import 'enterexit.dart';
//import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

double perpage = 1;

class TabSocManagement extends StatefulWidget {
  final SocManagement socmanagement;
  final Issue issue;

  TabSocManagement({
    Key key,
    this.socmanagement,
    this.issue,
  });

  @override
  _TabSocManagementState createState() => _TabSocManagementState();
}

class _TabSocManagementState extends State<TabSocManagement> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  //Position _currentPosition;
  //String _currentAddress = "Searching current location...";
  List data;
  //DateTime _firstdateTime;
  //DateTime _lastdateTime;
  //DateTime _dateTime;
  //get issueid => null;
  List<DropdownMenuItem<String>> listCategory = [];
  List<String> category = [
    "JPP",
    "Security Department",
    "SOC ICT Unit",
    "UUMIT"
  ];
  String currentCategory = 'JPP';

  List<DropdownMenuItem<String>> listStatus = [];

  List<String> status = ["New", "Progress", "Finish"];
  String currentStatus = 'New';
  List<DropdownMenuItem<String>> listMonth = [];
  List<String> month = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12"
  ];
  String currentMonth = '1';

  List<DropdownMenuItem<String>> listYear = [];
  List<String> year = [
    "2020",
    "2021",
    "2022",
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
    "2029",
    "2030"
  ];
  String currentYear = '2020';

  /*List<DropdownMenuItem<String>> listDay = [];
  List<String> day = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30",
    "31"
  ];
  String currentDay = '1';*/
  /*MonthPicker _month = MonthPicker.now();
  MonthPicker picked;

  Future<Null> selectTime(BuildContext context) async {
  picked = await showMonthPicker{
   context: context,
   initialMonth: _month,
  }
   setState(() {
     MonthPicker = picked;
     print(_time);
   });
  }*/

  void loadData() {
    listCategory = [];
    listCategory = category
        .map((val) => new DropdownMenuItem<String>(
              child: Text(val),
              value: val,
            ))
        .toList();

    listStatus = [];
    listStatus = status
        .map((val) => new DropdownMenuItem<String>(
              child: Text(val),
              value: val,
            ))
        .toList();

    listYear = [];
    listYear = year
        .map((val) => new DropdownMenuItem<String>(
              child: Text(val),
              value: val,
            ))
        .toList();

    listMonth = [];
    listMonth = month
        .map((val) => new DropdownMenuItem<String>(
              child: Text(val),
              value: val,
            ))
        .toList();

    /*listDay = [];
    listDay = day
        .map((val) => new DropdownMenuItem<String>(
              child: Text(val),
              value: val,
            ))
        .toList();*/
  }

  @override
  void initState() {
    super.initState();
    loadData();
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
        appBar: AppBar(title: Text('ISSUE'), backgroundColor: Colors.blue),
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
                                              widget.socmanagement.name
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
                                                widget.socmanagement.position),
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
                          child: Text("The Issue Report",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                        ),
                      ),
                      FormField(builder: (FormFieldState state) {
                        return InputDecorator(
                            decoration: InputDecoration(
                                labelText:
                                    'Please choose the Responsible Department: '),
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                items: category.map((String val) {
                                  return new DropdownMenuItem<String>(
                                    value: val,
                                    child: new Text(val),
                                  );
                                }).toList(),
                                hint: Text('Responsible Department'),
                                iconSize: 40.0,
                                elevation: 16,
                                onChanged: (String categorySave) {
                                  setState(() {
                                    issue.issuecategory = categorySave;
                                    currentCategory = categorySave;
                                    print(currentCategory);
                                  });
                                },
                                value: currentCategory,
                              ),
                            ));
                      }),
                      FormField(builder: (FormFieldState state) {
                        return InputDecorator(
                            decoration: InputDecoration(
                                labelText: 'Please choose the Issue Sataus: '),
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                items: status.map((String val) {
                                  return new DropdownMenuItem<String>(
                                    value: val,
                                    child: new Text(val),
                                  );
                                }).toList(),
                                hint: Text('Issue Status '),
                                iconSize: 40.0,
                                elevation: 16,
                                onChanged: (String statusSave) {
                                  setState(() {
                                    issue.issuestatus = statusSave;
                                    currentStatus = statusSave;
                                    print(currentStatus);
                                  });
                                },
                                value: currentStatus,
                              ),
                            ));
                      }),
                      FormField(builder: (FormFieldState state) {
                        return InputDecorator(
                            decoration: InputDecoration(
                                labelText: 'Please choose the Month: '),
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                items: month.map((String val) {
                                  return new DropdownMenuItem<String>(
                                    value: val,
                                    child: new Text(val),
                                  );
                                }).toList(),
                                hint: Text('Issue Month'),
                                iconSize: 40.0,
                                elevation: 16,
                                onChanged: (String monthSave) {
                                  setState(() {
                                    issue.issuetime = monthSave;
                                    currentMonth = monthSave;
                                    print(currentMonth);
                                  });
                                },
                                value: currentMonth,
                              ),
                            ));
                      }),
                      FormField(builder: (FormFieldState state) {
                        return InputDecorator(
                            decoration: InputDecoration(
                                labelText: 'Please choose the Year: '),
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                items: year.map((String val) {
                                  return new DropdownMenuItem<String>(
                                    value: val,
                                    child: new Text(val),
                                  );
                                }).toList(),
                                hint: Text('Issue Year'),
                                iconSize: 40.0,
                                elevation: 16,
                                onChanged: (String yearSave) {
                                  setState(() {
                                    issue.issuetime = yearSave;
                                    currentYear = yearSave;
                                    print(currentYear);
                                  });
                                },
                                value: currentYear,
                              ),
                            ));
                      }),

                      /*FormField(builder: (FormFieldState state) {
                                                        return InputDecorator(
                                                            decoration: InputDecoration(
                                                                labelText:
                                                                    'Please choose the Day that you want to search: '),
                                                            child: new DropdownButtonHideUnderline(
                                                              child: new DropdownButton<String>(
                                                                items: day.map((String val) {
                                                                  return new DropdownMenuItem<String>(
                                                                    value: val,
                                                                    child: new Text(val),
                                                                  );
                                                                }).toList(),
                                                                hint: Text('Issue Day'),
                                                                iconSize: 40.0,
                                                                elevation: 16,
                                                                onChanged: (String daySave) {
                                                                  setState(() {
                                                                    issue.issuetime = daySave;
                                                                    currentDay = daySave;
                                                                    print(currentDay);
                                                                  });
                                                                },
                                                                value: currentDay,
                                                              ),
                                                            ));
                                                      }),*/
                      /*Text(_firstdateTime == null
                                                          ? 'Nothing has been picked yet'
                                                          : _firstdateTime.toString()),
                                                      RaisedButton(
                                                        child: Text('Pick a First date'),
                                                        onPressed: () {
                                                          showDatePicker(
                                                                  context: context,
                                                                  initialDate: DateTime.now(),
                                                                  firstDate: DateTime(2020),
                                                                  lastDate: DateTime(2030))
                                                              .then((date) {
                                                            setState(() {
                                                              _firstdateTime = date;
                                                            });
                                                          });
                                                        },
                                                      ),
                                                      Text(_lastdateTime == null
                                                          ? 'Nothing has been picked yet'
                                                          : _lastdateTime.toString()),
                                                      RaisedButton(
                                                        child: Text('Pick a Last date'),
                                                        onPressed: () {
                                                          showDatePicker(
                                                                  context: context,
                                                                  initialDate: DateTime.now(),
                                                                  firstDate: DateTime(2020),
                                                                  lastDate: DateTime(2030))
                                                              .then((date) {
                                                            setState(() {
                                                              _lastdateTime = date;
                                                            });
                                                          });
                                                        },
                                                      ),
                                                      Text(_dateTime == null
                                                          ? 'Nothing has been picked yet'
                                                          : _dateTime.toString()),
                                                      RaisedButton(
                                                        child: Text('Pick a date'),
                                                        onPressed: () {
                                                          showDatePicker(
                                                                  context: context,
                                                                  initialDate: DateTime.now(),
                                                                  firstDate: DateTime(2020),
                                                                  lastDate: DateTime(2030))
                                                              .then((date) {
                                                            setState(() {
                                                              _dateTime = date;
                                                            });
                                                          });
                                                        },
                                                      ),*/
                      /*MaterialButton(
                                                        color: Colors.blueAccent,
                                                        onPressed: () async {
                                                          final List<DateTime> picked =
                                                              await DateRagePicker.showDatePicker(
                                                                  context: context,
                                                                  initialFirstDate: new DateTime.now(),
                                                                  initialLastDate: (new DateTime.now())
                                                                      .add(new Duration(days: 7)),
                                                                  firstDate: new DateTime(2015),
                                                                  lastDate: new DateTime(2020));
                                                          if (picked != null && picked.length == 2) {
                                                            print(picked);
                                                          }
                                                        },
                                                        child: new Text("Pick date range"),
                                                      ),*/
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('Search'),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        elevation: 15,
                        onPressed: _onSearch,
                      ),
                    ],
                  ),
                );
              }
              if (/*currentCategory == data[index]['issuecategory'] &&
                                                  currentStatus == data[index]['issuestatus'] &&
                                                  currentYear == data[index]['issuetime'] &&
                                                  currentMonth == data[index]['issuetime'] &&
                                                  currentDay == data[index]['issuetime'] &&*/
                  index == data.length && perpage > 1) {
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
              //currentCategory == issue.issuecategory;
              //currentStatus == issue.issuestatus;
              //currentCategory == data[index]['issuecategory'];
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
                        widget.socmanagement.position,
                        widget.socmanagement.name),
                    onLongPress: _onIssueDelete,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: <Widget>[
                          /*Container(
                                                                                      height: 100,
                                                                                      width: 100,
                                                                                      decoration: BoxDecoration(
                                                                                          shape: BoxShape.circle,
                                                                                          border: Border.all(color: Colors.white),
                                                                                          image: DecorationImage(
                                                                                              fit: BoxFit.fill,
                                                                                              image: NetworkImage(
                                                                                                  "http://limmuihoon.com/trackingsoc/images/${data[index]['issueimage']}.jpg")))),*/
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
                                  /*SizedBox(
                                    height: 10,
                                  ),*/
                                  Text(
                                      "Issue Category: " +
                                          data[index]['issuecategory']
                                              .toString()
                                              .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  /*SizedBox(
                                    height: 10,
                                  ),*/
                                  Text(
                                      "Issue Report By: " +
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
                                  Text(
                                      "Issue Status: " +
                                          data[index]['issuestatus']
                                              .toString()
                                              .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  /*SizedBox(
                                    height: 5,
                                  ),*/
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
    String urlLoadIssueSocmanagement =
        "http://limmuihoon.com/trackingsoc/php/load_issuesocmanagenent.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Report Issue");
    pr.show();
    http.post(urlLoadIssueSocmanagement, body: {
      "email": widget.socmanagement.email ?? "notavail",
      "position": widget.socmanagement.position ?? "notavail",
      //"issueid": widget.issue.issueid,
      "issuecategory": currentCategory,
      "issuestatus": currentStatus,
      "month": currentMonth,
      "year": currentYear,

      //"currentcategory": widget.issue.issuecategory,
      //"currentstatus": widget.issue.issuestatus,
      //"issuetime": currentYear,
      //"issuetime": currentMonth,
      //"issuetime": currentDay,
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["issue"];
        perpage = (data.length / 20);
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
            page: IssueDetail(
                issue: issue, socmanagement: widget.socmanagement)));
  }

  void _onIssueDelete() {
    print("Delete");
  }

  void _onSearch() {
    String urlLoadIssueSocmanagement =
        "http://limmuihoon.com/trackingsoc/php/load_issuesocmanagenent.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Report Issue");
    pr.show();
    http.post(urlLoadIssueSocmanagement, body: {
      "email": widget.socmanagement.email ?? "notavail",
      "position": widget.socmanagement.position ?? "notavail",
      //"issueid": widget.issue.issueid,
      "issuecategory": currentCategory,
      "issuestatus": currentStatus,
      "month": currentMonth,
      "year": currentYear,

      //"issuefirstday": _firstdateTime,
      //"issuelastday": _lastdateTime,
      //"issuetimeday": _dateTime,
      //"currentyear": widget.issue.issuetime,
      //"currentmonth": widget.issue.issuetime,
      //"currentday": widget.issue.issuetime,
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["issue"];
        perpage = (data.length / 20);
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
