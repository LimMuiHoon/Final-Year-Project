import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
//import 'package:tracking_soc/loginscreen.dart';
//import 'package:my_barter/payment.dart';
import 'package:tracking_soc/registrationscreen.dart';
import 'package:tracking_soc/splashscreen.dart';
import 'package:tracking_soc/staff.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';

//import 'package:intl/intl.dart';
//import 'package:random_string/random_string.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
String urlgetuser = "http://limmuihoon.com/trackingsoc/php/get_staffjpp.php";
String urluploadImage =
    "http://limmuihoon.com/trackingsoc/php/upload_imageprofile.php";
String urlupdate = "http://limmuihoon.com/trackingsoc/php/update_profile.php";
File _image;
int number = 0;
String _value;

class TabScreen3 extends StatefulWidget {
  //final String email;
  final Staff staff;
  TabScreen3({this.staff});

  @override
  _TabScreen3State createState() => _TabScreen3State();
}

class _TabScreen3State extends State<TabScreen3> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  /*final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";*/

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    //_getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blueAccent));
    //Size media = MediaQuery.of(context).size;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.blue[100],
          appBar: AppBar(title: Text('PROFILE'), backgroundColor: Colors.blue),
          body: SafeArea(
            top: false,
            child: ListView.builder(
                padding: EdgeInsets.only(top: 0),
                //Step 6: Count the data
                itemCount: 5,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(children: <Widget>[
                            Image.asset(
                              "assets/images/issue.jpg",
                              fit: BoxFit.fitWidth,
                            ),
                            Column(
                              children: <Widget>[
                                Center(
                                  child: Text("SOC Issue Tracking System",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: _takePicture,
                                  child: Container(
                                      width: 170.0,
                                      height: 170.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.white),
                                          image: new DecorationImage(
                                              fit: BoxFit.cover,
                                              image: new NetworkImage(
                                                  "http://limmuihoon.com/trackingsoc/profile/${widget.staff.email}.jpg?dummy=${(number)}'")))),
                                ),
                                SizedBox(height: 50),
                                /*Container(
                                  child: Text(
                                    widget.staff.name?.toUpperCase() ??
                                        'Not register',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),*/
                                Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.person,
                                          color: Colors.lime[600],
                                        ),
                                        Text(
                                          widget.staff.name?.toUpperCase() ??
                                              'Not register',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Text(
                                    widget.staff.email,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.phone_android,
                                          color: Colors.blueAccent,
                                        ),
                                        Text(widget.staff.phone ??
                                            'not registered'),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.info_outline,
                                          color: Colors.deepOrange,
                                        ),
                                        Text(widget.staff.position ??
                                            'not registered'),
                                      ],
                                    ),
                                  ],
                                ),
                                /*Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Icon(
                                                                    Icons.rate_review,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  RatingBar(
                                                                    itemCount: 5,
                                                                    itemSize: 12,
                                                                    initialRating: double.parse(
                                                                        widget.user.rating.toString() ?? 0.0),
                                                                    itemPadding:
                                                                        EdgeInsets.symmetric(horizontal: 2.0),
                                                                    itemBuilder: (context, _) => Icon(
                                                                      Icons.star,
                                                                      color: Colors.lightBlue,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),*/
                                /* Column(
                                                                children: <Widget>[
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons.rounded_corner,
                                                                      ),
                                                                      Text("Barter Radius " +
                                                                              widget.user.radius +
                                                                              "KM" ??
                                                                          'Barter Radius 0 KM'),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),*/
                                /*Column(
                                                                children: <Widget>[
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      Icon(
                                                                        Icons.credit_card,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 5,
                                                                      ),
                                                                      Flexible(
                                                                        child: Text("You have " +
                                                                                widget.user.credit +
                                                                                " Credit" ??
                                                                            "You have 0 Credit"),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),*/
                                /*Center(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: <Widget>[
                                                                    Icon(
                                                                      Icons.location_on,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Flexible(
                                                                      child: Text(_currentAddress),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),*/
                                /*SizedBox(
                                                                height: 5,
                                                              ),*/
                                Container(
                                  color: Colors.lightBlue,
                                  child: Center(
                                    child: Text("My Profile ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                          SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Center(
                                    child: Text("Settings: ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[850])),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }

                  if (index == 1) {
                    return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  highlightColor: Colors.white.withAlpha(50),
                                  onTap: _changeName,
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.person,
                                        color: Colors.lime[600],
                                      ),
                                      Text(
                                        'Change Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: _changePassword,
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.vpn_key,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        'Change Password',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: _changePhone,
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.phone_android,
                                        color: Colors.blueAccent,
                                      ),
                                      Text(
                                        'Change Phone No.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap:
                                      _changePosition, //()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CreditPurchase())),
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.deepOrange,
                                      ),
                                      Text(
                                        'Change Position',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: (_registerAccount),
                                  /*{
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserPoint(user: widget.user)));
                                  },*/
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.home,
                                        color: Colors.deepOrange,
                                      ),
                                      Text(
                                        'Register Account',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: _gotologoutPage,
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.exit_to_app,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                          /*MaterialButton(
                          onPressed: _changeName,
                          child: Text("CHANGE NAME"),
                        ),*/
                          /*MaterialButton(
                            onPressed: _changePassword,
                            child: Text("CHANGE PASSWORD"),
                          ),*/
                          /*MaterialButton(
                            onPressed: _changePhone,
                            child: Text("CHANGE PHONE"),
                          ),*/
                          /*MaterialButton(
                            onPressed: _changePosition,
                            child: Text("CHANGE POSITION"),
                          ),*/
                          /*MaterialButton(
                                                                                                                                                                                                                                                                                onPressed: _loadPayment,
                                                                                                                                                                                                                                                                                child: Text("BUY CREDIT"),
                                                                                                                                                                                                                                                                              ),*/
                          /*MaterialButton(
                            onPressed: _registerAccount,
                            child: Text("REGISTER"),
                          ),*/
                          /*MaterialButton(
                            onPressed: _gotologinPage,
                            child: Text("LOG IN"),
                          ),*/
                          /*MaterialButton(
                            onPressed: _gotologoutPage,
                            child: Text("LOG OUT"),
                          )*/
                        ],
                      ),
                    );
                  }
                }),
          ),
        ));
  }

  void _changeName() {
    TextEditingController nameController = TextEditingController();
    // flutter defined function

    if (widget.staff.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change name for " + widget.staff.name + "?"),
          content: new TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                icon: Icon(Icons.person),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (nameController.text.length < 5) {
                  Toast.show(
                      "Name should be more than 5 characters long", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.staff.email,
                  "name": nameController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.staff.name = dres[1];
                    });
                    Toast.show("Success", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    Navigator.of(context).pop();
                    return;
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Toast.show("Failed", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changePassword() {
    TextEditingController passController = TextEditingController();
    // flutter defined function
    print(widget.staff.name);
    if (widget.staff.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change Password for " + widget.staff.name),
          content: new TextField(
            controller: passController,
            decoration: InputDecoration(
              labelText: 'New Password',
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (passController.text.length < 5) {
                  Toast.show("Password too short", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.staff.email,
                  "password": passController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.staff.name = dres[1];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        savepref(passController.text);
                        Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changePhone() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.staff.name);
    if (widget.staff.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change phone for" + widget.staff.name),
          content: new TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'phone',
                icon: Icon(Icons.phone),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (phoneController.text.length < 5) {
                  Toast.show("Please enter correct phone number", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.staff.email,
                  "phone": phoneController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.staff.phone = dres[3];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  }
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerAccount() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.staff.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Register new account?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RegisterScreen()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /*void _gotologinPage() {
    // flutter defined function
    print(widget.staff.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Go to login page?" + widget.staff.name),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }*/

  void _gotologoutPage() {
    // flutter defined function
    print(widget.staff.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Go to login page?" + widget.staff.name),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SplashScreen()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void savepref(String pass) async {
    print('Inside savepref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pass', pass);
  }

  void _takePicture() {
    if (widget.staff.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Take new profile picture?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                _image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);

                String base64Image = base64Encode(_image.readAsBytesSync());
                http.post(urluploadImage, body: {
                  "encoded_string": base64Image,
                  "email": widget.staff.email,
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    setState(() {
                      number = new Random().nextInt(100);
                      print(number);
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changePosition() {
    TextEditingController positionController = TextEditingController();
    // flutter defined function

    if (widget.staff.position == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change position for " + widget.staff.name + "?"),
          content: new TextField(
              controller: positionController,
              decoration: InputDecoration(
                labelText: 'Position',
                icon: Icon(Icons.info_outline),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (positionController.text.length < 5) {
                  Toast.show(
                      "Position should be more than 5 characters long", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.staff.email,
                  "position": positionController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    //print('in success');
                    setState(() {
                      widget.staff.position = dres[4];
                    });
                    Toast.show("Success", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    Navigator.of(context).pop();
                    return;
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Toast.show("Failed", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

//class InfoCard {}
