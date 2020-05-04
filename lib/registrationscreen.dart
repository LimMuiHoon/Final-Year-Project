import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:tracking_soc/loginscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

String pathAsset = 'assets/images/profile.png';
String urlUploadStaff =
    "https://limmuihoon.com/trackingsoc/php/register_staff.php";
String urlUploadSocManagement =
    "http://limmuihoon.com/trackingsoc/php/register_socmanagement.php";
String urlUploadJpp = "http://limmuihoon.com/trackingsoc/php/register_jpp.php";
String urlUploadJabatanKeselamatan =
    "http://limmuihoon.com/trackingsoc/php/register_jabatankeselamatan.php";
String urlUploadPusatUnitIctSoc =
    "http://limmuihoon.com/trackingsoc/php/register_pusatunitictsoc.php";
String urlUploadUumit =
    "http://limmuihoon.com/trackingsoc/php/register_uumit.php";

File _image;
final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emcontroller = TextEditingController();
final TextEditingController _passcontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();
final TextEditingController _pocontroller = TextEditingController();
String _name, _email, _password, _phone, _position;
//bool _ischecked = false;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
  const RegisterScreen({Key key, File image}) : super(key: key);
}

class _RegisterUserState extends State<RegisterScreen> {
  @override
  void initState() {
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
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('New User Registration'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: RegisterWidget(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    _image = null;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  RegisterWidgetState createState() => RegisterWidgetState();
}

class RegisterWidgetState extends State<RegisterWidget> {
  GlobalKey<FormState> _globalKey = new GlobalKey();
  bool _autoValidate = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
            onTap: _choose,
            child: Container(
              width: 180,
              height: 200,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _image == null
                        ? AssetImage(pathAsset)
                        : FileImage(_image),
                    fit: BoxFit.fill,
                  )),
            )),
        Text('Click on image above to take profile picture'),
        Text('*Required take picture*', style: TextStyle(color: Colors.red)),
        TextFormField(
            controller: _emcontroller,
            autovalidate: _autoValidate,
            validator: _validateEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            )),
        TextFormField(
            controller: _namecontroller,
            autovalidate: _autoValidate,
            validator: _validateName,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Name',
              icon: Icon(Icons.person),
            )),
        TextFormField(
          controller: _passcontroller,
          autovalidate: _autoValidate,
          validator: _validatePassword,
          decoration:
              InputDecoration(labelText: 'Password', icon: Icon(Icons.lock)),
          obscureText: true,
        ),
        TextFormField(
            controller: _phcontroller,
            autovalidate: _autoValidate,
            validator: _validatePhone,
            keyboardType: TextInputType.phone,
            decoration:
                InputDecoration(labelText: 'Phone', icon: Icon(Icons.phone))),
        SizedBox(
          height: 10,
        ),
        TextFormField(
            controller: _pocontroller,
            autovalidate: _autoValidate,
            validator: _validatePosition,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: 'Position', icon: Icon(Icons.blur_circular))),
        SizedBox(
          height: 10,
        ),
        Text('Register as: ',
            style: TextStyle(fontSize: 15, letterSpacing: 0.1)),
        SizedBox(
          height: 5,
        ),

        /*MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          minWidth: 300,
          height: 50,
          child: Text('Staff'),
          color: Colors.blueAccent,
          textColor: Colors.white,
          elevation: 15,
          onPressed: _onStaffRegister,
        ),
        SizedBox(
          height: 10,
        ),*/
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
                onPressed: _onstaffRegister,
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
                onPressed: _onsocmanagementRegister,
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
                onPressed: _onjppRegister,
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
                onPressed: _onjabatanKeselamatanRegister,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                minWidth: 10,
                height: 30,
                child: Text(
                  'SOC ICT Unit',
                  style: TextStyle(fontSize: 18, letterSpacing: 0.8),
                ),
                color: Colors.blue[700],
                textColor: Colors.white,
                elevation: 15,
                onPressed: _onpusatictsocRegister,
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
                onPressed: _onjppRegister,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
            onTap: _onBackPress,
            child: Text('Already Register', style: TextStyle(fontSize: 16))),
      ],
    );
  }

  void _choose() async {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(40),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () async {
                    _image = await ImagePicker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 60,
                        maxHeight: 250,
                        maxWidth: 250);
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text('Gallery'),
                  onTap: () async {
                    _image = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 60,
                        maxHeight: 250,
                        maxWidth: 250);
                    setState(() {});
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
    //selection==null?_image = await ImagePicker.pickImage(source: ImageSource.camera):await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  String _validateEmail(String value) {
    // The form is empty
    if (value.length == 0) {
      return "Please enter your email";
    }
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }
    return 'Email is not valid';
  }

  String _validateName(String value) {
    if (value.length == 0) {
      return "Please enter your name";
    } else {
      return null;
    }
  }

  String _validatePassword(String value) {
    if (value.length == 0) {
      return "Please enter your password";
    } else if (value.length < 6) {
      return "Password must at least 6 characters";
    } else {
      return null;
    }
  }

  String _validatePhone(String value) {
    String p = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(p);
    if (value.length == 0) {
      return "Please enter your phone number";
    } else if (value.length < 9 || value.length > 11) {
      return "Phone number must 10-11 digits";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter correct phone number";
    }
  }

  String _validatePosition(String value) {
    if (value.length == 0) {
      return "Please enter your current position in UUM SOC";
    } else {
      return null;
    }
  }

  void _onstaffRegister() {
    print('onRegister Button from RegisterStaff()');
    print(_image.toString());
    uploadStaffData();
  }

  void _onBackPress() {
    _image = null;
    print('onBackpress from RegisterUser');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  void uploadStaffData() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;
    _position = _pocontroller.text;

    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_image != null) &&
        (_phone.length > 5) &&
        _position.length > 2) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUploadStaff, body: {
        "encoded_string": base64Image,
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
        "position": _position,
      }).then((res) {
        print(res.statusCode);
        if (res.body == "success") {
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _image = null;
          savepref(_email, _password);
          _namecontroller.text = '';
          _emcontroller.text = '';
          _phcontroller.text = '';
          _passcontroller.text = '';
          _pocontroller.text = '';
          pr.dismiss();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void savepref(String email, String pass) async {
    print('Inside savepref');
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //true save pref
    await prefs.setString('email', email);
    await prefs.setString('pass', pass);
    print('Save pref $_email');
    print('Save pref $_password');
  }

  void _onsocmanagementRegister() {
    print('onRegister Button from RegisterSOCManagement()');
    print(_image.toString());
    uploadSocManagementData();
  }

  void uploadSocManagementData() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;
    _position = _pocontroller.text;

    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_image != null) &&
        (_phone.length > 5) &&
        (_position.length > 2)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUploadSocManagement, body: {
        "encoded_string": base64Image,
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
        "position": _position,
      }).then((res) {
        print(res.statusCode);
        if (res.body == "success") {
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _image = null;
          savepref(_email, _password);
          _namecontroller.text = '';
          _emcontroller.text = '';
          _phcontroller.text = '';
          _passcontroller.text = '';
          _pocontroller.text = '';
          pr.dismiss();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _onjppRegister() {
    print('onRegister Button from RegisterJpp()');
    print(_image.toString());
    uploadJppData();
  }

  void uploadJppData() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;
    _position = _pocontroller.text;

    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_image != null) &&
        (_phone.length > 5) &&
        (_position.length > 2)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUploadJpp, body: {
        "encoded_string": base64Image,
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
        "position": _position,
      }).then((res) {
        print(res.statusCode);
        if (res.body == "success") {
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _image = null;
          savepref(_email, _password);
          _namecontroller.text = '';
          _emcontroller.text = '';
          _phcontroller.text = '';
          _passcontroller.text = '';
          _pocontroller.text = '';
          pr.dismiss();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _onjabatanKeselamatanRegister() {
    print('onRegister Button from RegisterJabatanKeselamatan()');
    print(_image.toString());
    uploadJabatanKeselamatanData();
  }

  void uploadJabatanKeselamatanData() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;
    _position = _pocontroller.text;

    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_image != null) &&
        (_phone.length > 5) &&
        (_position.length > 2)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUploadJabatanKeselamatan, body: {
        "encoded_string": base64Image,
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
        "position": _position,
      }).then((res) {
        print(res.statusCode);
        if (res.body == "success") {
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _image = null;
          savepref(_email, _password);
          _namecontroller.text = '';
          _emcontroller.text = '';
          _phcontroller.text = '';
          _passcontroller.text = '';
          _pocontroller.text = '';
          pr.dismiss();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _onpusatictsocRegister() {
    print('onRegister Button from RegisterPusatUnitIctSoc()');
    print(_image.toString());
    uploadPusatUnitIctSocData();
  }

  void uploadPusatUnitIctSocData() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;
    _position = _pocontroller.text;

    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_image != null) &&
        (_phone.length > 5) &&
        (_position.length > 2)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUploadPusatUnitIctSoc, body: {
        "encoded_string": base64Image,
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
        "position": _position,
      }).then((res) {
        print(res.statusCode);
        if (res.body == "success") {
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _image = null;
          savepref(_email, _password);
          _namecontroller.text = '';
          _emcontroller.text = '';
          _phcontroller.text = '';
          _passcontroller.text = '';
          _pocontroller.text = '';
          pr.dismiss();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _onuumitLogin() {
    print('onRegister Button from RegisterUUMIT()');
    print(_image.toString());
    uploadUumitData();
  }

  void uploadUumitData() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;
    _position = _pocontroller.text;

    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_image != null) &&
        (_phone.length > 5) &&
        (_position.length > 2)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUploadUumit, body: {
        "encoded_string": base64Image,
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
        "position": _position,
      }).then((res) {
        print(res.statusCode);
        if (res.body == "success") {
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _image = null;
          savepref(_email, _password);
          _namecontroller.text = '';
          _emcontroller.text = '';
          _phcontroller.text = '';
          _passcontroller.text = '';
          _pocontroller.text = '';
          pr.dismiss();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
