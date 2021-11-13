import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickshare_client/components/home/ProfileDialog.dart';
import 'package:quickshare_client/components/home/QuickBeneficiary.dart';
import 'package:quickshare_client/components/home/Transactions.dart';
import 'package:quickshare_client/config/Env.dart';
import 'package:quickshare_client/contexts/BeneficiaryContext.dart';
import 'package:quickshare_client/contexts/UserContext.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: non_constant_identifier_names
  String BASE_URL = Env().BASE_URL;

  _showProfilePageDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return ProfileDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map user = Provider.of<UserContext>(context, listen: false).getUser();
    List? beneficiaries =
        Provider.of<BeneficiaryContext>(context, listen: false)
            .getBeneficiaries();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello,",
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(47, 47, 47, 1)),
                  ),
                  Text(
                    "${user['username']}",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color.fromRGBO(47, 47, 47, 1)),
                  )
                ],
              ),
              GestureDetector(
                onTap: _showProfilePageDialog,
                child: user['profile_photo'] != null
                    ? ClipOval(
                        child: Image.network(
                        BASE_URL + user['profile_photo'],
                        fit: BoxFit.cover,
                        height: 52,
                        width: 52,
                      ))
                    : ClipOval(
                        child: Image.asset(
                        'assets/images/user.png',
                        fit: BoxFit.cover,
                        height: 52,
                        width: 52,
                      )),
              )
            ],
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...beneficiaries!
                    .map((e) => QuickBeneficiary(
                          beneficiaryDetails: e,
                        ))
                    .toList()
              ],
            ),
          ),
          Text(
            "\nShared Files",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Transactions()
        ],
      ),
    );
  }
}
