import 'package:cinemaque/pages/Landing_Page.dart';
import 'package:flutter/material.dart';
import 'package:cinemaque/login/authentication.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth.dart';

class UserModel {
  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=------- user you firebase key here -----------',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=------- user you firebase key here -----------',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';

    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", responseData["idToken"]);
      prefs.setString("email", responseData["email"]);
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists !';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String email = prefs.getString("email");
    if (token != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LandingPage(email)));
    } else {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context) => AuthPage()));
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("email");
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String e = prefs.getString("email");
    return e;
  }
}
