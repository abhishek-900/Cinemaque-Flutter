import 'package:cinemaque/login/Connection.dart';
import 'package:cinemaque/pages/Landing_Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cinemaque/login/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}
class _AuthPageState extends State<AuthPage> {
  Image myImage;
  Future<int> id;
  String userName;
  String password;
  var bColor;
  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser userDetails;
  SharedPreferences prefs;
  FirebaseUser currentUser;

  @override
  void initState() {
    myImage = Image.asset(
      "images/newimage.jpg",
      width: double.maxFinite,
      height: 260,
      fit: BoxFit.cover,
    );
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(myImage.image, context);
  }
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  Widget _buildEmailTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintStyle:
              TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.6)),
          hintText: "Email",
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(30))),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }
  Widget _buildPasswordTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintStyle:
              TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.6)),
          hintText: "Password",
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(30))),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }
  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintStyle:
              TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.6)),
          hintText: "Confirm Password",
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(30))),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Passwords do not match.';
        }
        return null;
      },
    );
  }
  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      activeColor: Color(0xff4285f4),
      inactiveTrackColor: Colors.white,
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text(
        'Accept Terms',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation = await UserModel()
        .authenticate(_formData['email'], _formData['password'], _authMode);
    if (successInformation['success']) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LandingPage(_formData['email'])));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();

                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height+100,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    myImage,
                    Positioned(
                      top: 185,
                      child: Container(
                        padding: EdgeInsets.only(left: 30, right: 30, top: 78),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Color(0xff262626),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(70.5),
                              topRight: Radius.circular(70.5),
                            )),
                        child: Column(
                          children: <Widget>[
                            _buildEmailTextField(),
                            SizedBox(
                              height: 10.0,
                            ),
                            _buildPasswordTextField(),
                            SizedBox(
                              height: 10.0,
                            ),
                            _authMode == AuthMode.Signup
                                ? _buildPasswordConfirmTextField()
                                : Container(),
                            _buildAcceptSwitch(),
                            SizedBox(
                              height: 10.0,
                            ),
                            FlatButton(
                              child: Text(
                                'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {

                                setState(() {
                                  _authMode = _authMode == AuthMode.Login
                                      ? AuthMode.Signup
                                      : AuthMode.Login;
                                });
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              width: 250,
                              height: 50,
                              child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Color(0xff4285f4),
                                  child: Text(
                                    _authMode == AuthMode.Login
                                        ? 'LOGIN'
                                        : 'SIGNUP',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {
                                    _submitForm();
                                  }),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}