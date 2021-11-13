import 'package:flutter/material.dart';
import 'package:quickshare_client/components/static/TopWelcomeText.dart';
import 'package:quickshare_client/components/auth/CreateAccountForm.dart';



class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6CC9E1),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 22, horizontal: 20),
          child: SingleChildScrollView(
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
                        "Create an Account",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                CreateAccountForm(),
                SizedBox(
                  height: 18,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? "),
                      GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
