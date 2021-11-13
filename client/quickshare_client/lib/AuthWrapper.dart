import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickshare_client/contexts/BeneficiaryContext.dart';
import 'package:quickshare_client/contexts/TransactionContext.dart';
import 'package:quickshare_client/contexts/UserContext.dart';
import 'package:quickshare_client/helpers/HomeHelper.dart';
import 'package:quickshare_client/screens/BottomNavigationContainer.dart';
import 'package:quickshare_client/screens/auth/LoginScreen.dart';
import 'package:quickshare_client/screens/auth/OTPValidationScreen.dart';
import 'package:quickshare_client/screens/home/HomeScreen.dart';
import 'package:quickshare_client/screens/static/ErrorPage.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  _setPage() async {
    await HomeHelper().getHomeData(onSuccess: (data) {
      Provider.of<UserContext>(context, listen: false).setUser(data['user']);
      Provider.of<TransactionContext>(context, listen: false)
          .setTransactions(data['transactions']);
      Provider.of<BeneficiaryContext>(context, listen: false)
          .setBeneficiaries(data['beneficiaries']);

      if (!data['user']['is_verified']) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => OTPValidationScreen(email: data['user']['email'])));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => BottomNavigationContainer()));
      }
    }, onError: (error) {
      print(error);
      if (error == 'Unauthorized') {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => ErrorPage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _setPage();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  )),
              Text("\nLoading...")
            ],
          )),
        ),
      );
}
