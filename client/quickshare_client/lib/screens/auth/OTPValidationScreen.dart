import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:quickshare_client/helpers/AuthHelper.dart';
import 'package:quickshare_client/screens/auth/LoginScreen.dart';

// ignore: must_be_immutable
class OTPValidationScreen extends StatefulWidget {
  String email;
  OTPValidationScreen({required this.email});

  @override
  _OTPValidationScreenState createState() =>
      _OTPValidationScreenState(this.email);
}

class _OTPValidationScreenState extends State<OTPValidationScreen> {
  String email;
  String otp = '';
  bool isOTPSent = false;
  bool isLoading = false;

  _OTPValidationScreenState(this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 22, horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(top: 6, bottom: 2),
              child: Text(
                "Verify Account",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff6CC9E1)),
              ),
            ),
            Divider(),
            Text("\nYour Email"),
            Text(
              "$email",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            isOTPSent
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("\nEnter OTP"),
                      OTPTextField(
                        length: 5,
                        onCompleted: (_) {},
                        onChanged: (val) {
                          otp = val;
                        },
                        width: MediaQuery.of(context).size.width,
                        fieldWidth: 46,
                      ),
                    ],
                  )
                : SizedBox(),
            Container(
              margin: EdgeInsets.only(top: 24),
              width: double.maxFinite,
              child: MaterialButton(
                  child: isLoading
                      ? SizedBox(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blueGrey,
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                          height: 12,
                          width: 12,
                        )
                      : Text(
                          isOTPSent ? "VERIFY ACCOUNT" : "SEND OTP",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                  elevation: 0,
                  disabledColor: Colors.blueGrey,
                  color: Color(0xff479FBE),
                  onPressed: isLoading
                      ? null
                      : !isOTPSent
                          ? () async {
                              setState(() {
                                isLoading = true;
                              });
                              await AuthHelper()
                                  .requestAccountVerificationAtBackend(
                                      onSuccess: (res) {
                                setState(() {
                                  isLoading = false;
                                  isOTPSent = true;
                                });
                              }, onError: (err) {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(err),
                                  backgroundColor: Colors.red,
                                ));
                              });
                            }
                          : () async {
                              setState(() {
                                isLoading = true;
                              });
                              AuthHelper().verifyWithOTP(
                                  otp: otp,
                                  onSuccess: (res) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(res['msg'])));
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                LoginScreen(email, null)));
                                  },
                                  onError: (err) {
                                    print(err);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(err)));
                                  });
                            }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Center(
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Text("Resend OTP"))),
            )
          ]),
        ),
      ),
    );
  }
}
