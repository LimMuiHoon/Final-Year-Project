import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tracking_soc/staff.dart';
import 'package:tracking_soc/mainscreen.dart';
//import 'mainscreen.dart';
//import 'staff.dart';
import 'package:tracking_soc/socmanagement.dart';
import 'package:tracking_soc/mainscreensocmanagement.dart';
import 'package:tracking_soc/jpp.dart';
import 'package:tracking_soc/mainscreenjpp.dart';
import 'package:tracking_soc/jabatankeselamatan.dart';
import 'package:tracking_soc/mainscreenjabatankeselamatan.dart';
import 'package:tracking_soc/pusatunitictsoc.dart';
import 'package:tracking_soc/mainscreenpusatunitictsoc.dart';
import 'package:tracking_soc/uumit.dart';
import 'package:tracking_soc/mainscreenuumit.dart';
import 'package:tracking_soc/registrationscreen.dart';
import 'package:tracking_soc/forgotpasswordscreen.dart';
import 'package:tracking_soc/forgotpasswordsoc.dart';
import 'package:tracking_soc/forgotpasswprdsecuritydepartment.dart';
import 'package:tracking_soc/forgotpasswordsocunitict.dart';
import 'package:tracking_soc/forgotpassworduumit.dart';
import 'package:tracking_soc/forgotpasswordjpp.dart';

String urlLoginStaff = "https://limmuihoon.com/trackingsoc/php/login_staff.php";
String urlLoginSocManagement =
    "http://limmuihoon.com/trackingsoc/php/login_socmanagement.php";
String urlLoginJPP = "http://limmuihoon.com/trackingsoc/php/login_jpp.php";
String urlLoginJabatanKeselamatan =
    "http://limmuihoon.com/trackingsoc/php/login_jabatankeselamatan.php";
String urlLoginPusatUnitICTSOC =
    "http://limmuihoon.com/trackingsoc/php/login_pusatunitictsoc.php";
String urlLoginUUMIT = "http://limmuihoon.com/trackingsoc/php/login_uumit.php";
bool _isChecked = false;
final TextEditingController _emcontroller = TextEditingController();
String _email = "";
final TextEditingController _passcontroller = TextEditingController();
String _password = "";

void main() => runApp(MyApp());

Staff staff = new Staff();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: new ThemeData(
          backgroundColor: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFEFEFEF),
          primarySwatch: Colors.red),
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  @override
  void initState() {
    _loadpref();
    print('Init: $_email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blueAccent));
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: SingleChildScrollView(
            child: new Container(
              padding: EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo.png',
                    //scale: 1.5,
                    width: 150,
                    height: 150,
                  ),
                  TextFormField(
                      autovalidate: _validate,
                      controller: _emcontroller,
                      validator: validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email))),
                  TextFormField(
                    autovalidate: _validate,
                    controller: _passcontroller,
                    validator: validatePassword,
                    decoration: InputDecoration(
                        labelText: 'Password', icon: Icon(Icons.lock)),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  /*Text('Please Select your Category: ',
                    style: TextStyle(fontSize: 20)),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 300,
                  height: 50,
                  child: Text('Staff'),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  elevation: 15,
                  onPressed: _onstaffLogin,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 300,
                  height: 50,
                  child: Text('SOC Management'),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  elevation: 15,
                  onPressed: _onsocmanagementLogin,
                ),
                SizedBox(
                  height: 10,
                ),*/
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool value) {
                          _onChange(value);
                        },
                      ),
                      Text('Remember Me', style: TextStyle(fontSize: 16))
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Login as: ',
                      style: TextStyle(fontSize: 15, letterSpacing: 0.1)),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minWidth: 10,
                          height: 30,
                          child: Text(
                            'Staff',
                            style: TextStyle(fontSize: 18, letterSpacing: 0.8),
                          ),
                          color: Colors.blue[700],
                          textColor: Colors.white,
                          elevation: 15,
                          onPressed: _onstaffLogin,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minWidth: 10,
                          height: 30,
                          child: Text(
                            'SOC Management',
                            style: TextStyle(fontSize: 18, letterSpacing: 0.8),
                          ),
                          color: Colors.blue[700],
                          textColor: Colors.white,
                          elevation: 15,
                          onPressed: _onsocmanagementLogin,
                        ),
                        /*MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 10,
                        height: 30,
                        child: Text(
                          'JPP',
                          style: TextStyle(fontSize: 18, letterSpacing: 0.8),
                        ),
                        color: Colors.blue[700],
                        textColor: Colors.white,
                        elevation: 15,
                        onPressed: _onjppLogin,
                      ),*/
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minWidth: 10,
                          height: 30,
                          child: Text(
                            'Security Department',
                            style: TextStyle(fontSize: 18, letterSpacing: 0.8),
                          ),
                          color: Colors.blue[700],
                          textColor: Colors.white,
                          elevation: 15,
                          onPressed: _onjabatanKeselamatanLogin,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minWidth: 10,
                          height: 30,
                          child: Text(
                            'SOC Unit ICT',
                            style: TextStyle(fontSize: 18, letterSpacing: 0.8),
                          ),
                          color: Colors.blue[700],
                          textColor: Colors.white,
                          elevation: 15,
                          onPressed: _onpusatictsocLogin,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minWidth: 10,
                          height: 30,
                          child: Text(
                            'UUMIT',
                            style: TextStyle(fontSize: 18, letterSpacing: 0.8),
                          ),
                          color: Colors.blue[700],
                          textColor: Colors.white,
                          //elevation: 15,
                          onPressed: _onuumitLogin,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minWidth: 10,
                          height: 30,
                          child: Text(
                            'JPP',
                            style: TextStyle(fontSize: 18, letterSpacing: 0.8),
                          ),
                          color: Colors.blue[700],
                          textColor: Colors.white,
                          elevation: 15,
                          onPressed: _onjppLogin,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: _onRegister,
                      child: Text('Register New Account',
                          style: TextStyle(fontSize: 16))),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: _onForgot,
                      child: Text('Forgot Password For Staff',
                          style: TextStyle(fontSize: 14))),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: _onForgotSOC,
                      child: Text('Forgot Password For SOC Management',
                          style: TextStyle(fontSize: 14))),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: _onForgotSecurityDept,
                      child: Text('Forgot Password For Security Department',
                          style: TextStyle(fontSize: 14))),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: _onForgotSOCUnitICT,
                      child: Text('Forgot Password For SOC Unit ICT',
                          style: TextStyle(fontSize: 14))),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: _onForgotUUMIT,
                      child: Text('Forgot Password For UUMIT',
                          style: TextStyle(fontSize: 14))),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: _onForgotJPP,
                      child: Text('Forgot Password For JPP',
                          style: TextStyle(fontSize: 14))),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is Required";
    } else if (value.length < 6) {
      return "Password must at least 6 characters";
    } else {
      return null;
    }
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      print('Check value $value');
      _savePref(value);
    });
  }

  bool _isEmailValid(String email) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid;
  }

  Future _savePref(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    if (value) {
      //Store value from pref
      if (_isEmailValid(_email)) {
        await prefs.setString('email', _email);
        await prefs.setString('pass', _password);
        print('Pref Stored');
      } else {
        print('email invalid!!');
        setState(() {
          _isChecked = false;
        });
      }
    } else {
      //Remove value from pref
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emcontroller.text = '';
        _passcontroller.text = '';
        _isChecked = false;
      });
      print('pref removed');
      Toast.show("Preferences have been removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  Future _loadpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _password = (prefs.getString('pass'));
    print(_email);
    print(_password);
    if (_email.length > 1) {
      _emcontroller.text = _email;
      _passcontroller.text = _password;
      setState(() {
        _isChecked = true;
      });
    } else {
      //print('No pref');
      setState(() {
        _isChecked = false;
      });
    }
  }

  void _onRegister() {
    print('onRegister');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  void _onForgot() {
    print('Forgot');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }

  void _onstaffLogin() {
    _email = _emcontroller.text;
    _password = _passcontroller.text;

    if (_isEmailValid(_email) && (_password.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login In");
      pr.show();
      http.post(urlLoginStaff, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          pr.dismiss();
          // print("Radius:");
          print(dres);
          Staff staff = new Staff(
              name: dres[1], email: dres[2], phone: dres[3], position: dres[4]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(staff: staff)));
        } else {
          pr.dismiss();
        }
      }).catchError((error) {
        pr.dismiss();
        print(error);
      });
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  void _onsocmanagementLogin() {
    _email = _emcontroller.text;
    _password = _passcontroller.text;

    if (_isEmailValid(_email) && (_password.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login In");
      pr.show();
      http.post(urlLoginSocManagement, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          pr.dismiss();
          // print("Radius:");
          print(dres);
          SocManagement socmanagement = new SocManagement(
              name: dres[1], email: dres[2], phone: dres[3], position: dres[4]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MainScreenSocManagement(socmanagement: socmanagement)));
        } else {
          pr.dismiss();
        }
      }).catchError((error) {
        pr.dismiss();
        print(error);
      });
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  void _onjppLogin() {
    _email = _emcontroller.text;
    _password = _passcontroller.text;

    if (_isEmailValid(_email) && (_password.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login In");
      pr.show();
      http.post(urlLoginJPP, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          pr.dismiss();
          // print("Radius:");
          print(dres);
          JPP jpp = new JPP(
              name: dres[1], email: dres[2], phone: dres[3], position: dres[4]);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MainScreenJPP(jpp: jpp)));
        } else {
          pr.dismiss();
        }
      }).catchError((error) {
        pr.dismiss();
        print(error);
      });
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  void _onjabatanKeselamatanLogin() {
    _email = _emcontroller.text;
    _password = _passcontroller.text;

    if (_isEmailValid(_email) && (_password.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login In");
      pr.show();
      http.post(urlLoginJabatanKeselamatan, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          pr.dismiss();
          // print("Radius:");
          print(dres);
          JabatanKeselamatan jabatankeselamatan = new JabatanKeselamatan(
              name: dres[1], email: dres[2], phone: dres[3], position: dres[4]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreenJabatanKeselamatan(
                      jabatankeselamatan: jabatankeselamatan)));
        } else {
          pr.dismiss();
        }
      }).catchError((error) {
        pr.dismiss();
        print(error);
      });
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  void _onpusatictsocLogin() {
    _email = _emcontroller.text;
    _password = _passcontroller.text;

    if (_isEmailValid(_email) && (_password.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login In");
      pr.show();
      http.post(urlLoginPusatUnitICTSOC, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          pr.dismiss();
          // print("Radius:");
          print(dres);
          PusatUnitICTSOC pusatunitictsoc = new PusatUnitICTSOC(
              name: dres[1], email: dres[2], phone: dres[3], position: dres[4]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreenPusatUnitICTSOC(
                      pusatunitictsoc: pusatunitictsoc)));
        } else {
          pr.dismiss();
        }
      }).catchError((error) {
        pr.dismiss();
        print(error);
      });
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  void _onuumitLogin() {
    _email = _emcontroller.text;
    _password = _passcontroller.text;

    if (_isEmailValid(_email) && (_password.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login In");
      pr.show();
      http.post(urlLoginUUMIT, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "success") {
          pr.dismiss();
          // print("Radius:");
          print(dres);
          UUMIT uumit = new UUMIT(
              name: dres[1], email: dres[2], phone: dres[3], position: dres[4]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreenUUMIT(uumit: uumit)));
        } else {
          pr.dismiss();
        }
      }).catchError((error) {
        pr.dismiss();
        print(error);
      });
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  void _onForgotSOC() {
    print('Forgot');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ForgotPasswordSOCScreen()));
  }

  void _onForgotSecurityDept() {
    print('Forgot');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForgotPasswordSecurityDeptScreen()));
  }

  void _onForgotSOCUnitICT() {
    print('Forgot');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForgotPasswordSOCUnitICTScreen()));
  }

  void _onForgotUUMIT() {
    print('Forgot');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ForgotPasswordUUMITScreen()));
  }

  void _onForgotJPP() {
    print('Forgot');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ForgotPasswordJPPScreen()));
  }
}
