import 'package:flutter/material.dart';
import 'package:quickshare_client/AuthWrapper.dart';
import 'package:quickshare_client/components/static/TopWelcomeText.dart';
import 'package:quickshare_client/helpers/AuthHelper.dart';
import 'package:quickshare_client/screens/auth/CreateAccountScreen.dart';

class LoginScreen extends StatefulWidget {
  final String? email, password;
  LoginScreen([this.email, this.password]);

  @override
  _LoginScreenState createState() => _LoginScreenState(email, password);
}

class _LoginScreenState extends State<LoginScreen> {
  final String? email, password;
  _LoginScreenState(this.email, this.password);

  Map _credentials = {
    'email': '',
    'password': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isWaiting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6CC9E1),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 22, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopWelcomeText(),
                  Divider(
                    height: 8,
                    thickness: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6, bottom: 2),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding:
                                EdgeInsets.only(bottom: 0, left: 14, right: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6)),
                            child: Center(
                                child: TextFormField(
                              validator: (String? e) {
                                if (!(e!.contains('.') && e.contains('@'))) {
                                  return 'Please provide an valid email.';
                                }
                              },
                              initialValue: email,
                              onSaved: (String? e) {
                                setState(() {
                                  _credentials['email'] = e!.trim();
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: "Email", border: InputBorder.none),
                            )),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 2),
                            padding:
                                EdgeInsets.only(bottom: 0, left: 14, right: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6)),
                            child: Center(
                                child: TextFormField(
                              obscureText: true,
                              validator: (String? e) {
                                if (e!.length < 6) {
                                  return 'Password too short.';
                                }
                              },
                              initialValue: password,
                              onSaved: (String? e) {
                                setState(() {
                                  _credentials['password'] = e!.trim();
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  border: InputBorder.none),
                            )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            width: double.maxFinite,
                            child: MaterialButton(
                                disabledColor: Colors.blueGrey,
                                child: _isWaiting
                                    ? Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 14,
                                              width: 14,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              "Please Wait",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )
                                    : Text(
                                        "LOGIN",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white),
                                      ),
                                elevation: 0,
                                color: Color(0xff479FBE),
                                onPressed: _isWaiting
                                    ? null
                                    : () async {
                                        setState(() {
                                          _isWaiting = true;
                                        });
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          await AuthHelper().loginAtBackend(
                                              onSuccess: (data) {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                AuthWrapper()));
                                              },
                                              onError: (err) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(err.toString()),
                                                  backgroundColor: Colors.red,
                                                ));
                                              },
                                              credentials: _credentials);
                                        }
                                        setState(() {
                                          _isWaiting = false;
                                        });
                                      }),
                          )
                        ],
                      ))
                ],
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont have an account? "),
                    GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CreateAccountScreen())),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
