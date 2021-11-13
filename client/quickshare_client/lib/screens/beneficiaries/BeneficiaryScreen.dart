import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickshare_client/config/Env.dart';
import 'package:quickshare_client/contexts/BeneficiaryContext.dart';
import 'package:quickshare_client/contexts/TransactionContext.dart';
import 'package:quickshare_client/contexts/UserContext.dart';
import 'package:quickshare_client/helpers/HomeHelper.dart';
import 'package:quickshare_client/screens/auth/LoginScreen.dart';
import 'package:quickshare_client/screens/auth/OTPValidationScreen.dart';
import 'package:quickshare_client/components/beneficiary/AddBeneficiaryDialog.dart';
import 'package:quickshare_client/screens/static/ErrorPage.dart';

class BeneficiaryScreen extends StatefulWidget {
  @override
  _BeneficiaryScreenState createState() => _BeneficiaryScreenState();
}

class _BeneficiaryScreenState extends State<BeneficiaryScreen> {
  List beneficiaries = [];
  List? ctxBeneficiaries;

  Future _addBeneficiaryDialog(String username) async {
    return await showDialog(
        context: context, builder: (context) => AddBeneficiaryDialog(username));
  }

  Future _refresh() async {
    await HomeHelper().getHomeData(onSuccess: (data) {
      setState(() {
        Provider.of<UserContext>(context, listen: false).setUser(data['user']);
        Provider.of<TransactionContext>(context, listen: false)
            .setTransactions(data['transactions']);
        Provider.of<BeneficiaryContext>(context, listen: false)
            .setBeneficiaries(data['beneficiaries']);
      });

      if (!data['user']['is_verified']) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => OTPValidationScreen(email: data['user']['email'])));
      }
    }, onError: (error) {
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
    setState(() {
      ctxBeneficiaries = Provider.of<BeneficiaryContext>(context, listen: false)
          .getBeneficiaries();
      beneficiaries = ctxBeneficiaries!;
    });
  }

  _searchBeneficiary(String query) {
    setState(() {
      beneficiaries = ctxBeneficiaries!
          .where((element) => element['beneficiary']['name'].contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Beneficiaries",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color.fromRGBO(47, 47, 47, 1)),
              ),
              GestureDetector(
                onTap: () async {
                  Map? user = Provider.of<UserContext>(context, listen: false)
                      .getUser();
                  _addBeneficiaryDialog(user!['username']);
                },
                child: Text("Add Beneficiary",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.blue,
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 14,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xff6CC9E1)),
            child: TextFormField(
              onChanged: (val) {
                _searchBeneficiary(val);
              },
              decoration: InputDecoration.collapsed(
                hintText: "Search Beneficiary",
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
              child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
                itemCount: beneficiaries.length,
                itemBuilder: (_, index) => ListTile(
                      leading: beneficiaries[index]['beneficiary']
                                  ['profile_photo'] ==
                              null
                          ? ClipOval(
                              child: Image.asset(
                                'assets/images/user.png',
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipOval(
                              child: Image.network(
                                '${Env().BASE_URL + beneficiaries[index]['beneficiary']['profile_photo']}',
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                      title: Text(" "+beneficiaries[index]['beneficiary']['name']),
                    )),
          ))
        ],
      ),
    );
  }
}
