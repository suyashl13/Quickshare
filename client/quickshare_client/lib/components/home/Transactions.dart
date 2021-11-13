import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickshare_client/contexts/BeneficiaryContext.dart';
import 'package:quickshare_client/contexts/TransactionContext.dart';
import 'package:quickshare_client/contexts/UserContext.dart';
import 'package:quickshare_client/helpers/HomeHelper.dart';
import 'package:quickshare_client/screens/auth/LoginScreen.dart';
import 'package:quickshare_client/screens/auth/OTPValidationScreen.dart';
import 'package:quickshare_client/screens/static/ErrorPage.dart';
import 'package:quickshare_client/screens/transactions/TransactionDetailsScreen.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    List? transactions = Provider.of<TransactionContext>(context, listen: false)
        .getTransactions();

    Future _refresh() async {
      await HomeHelper().getHomeData(onSuccess: (data) {
        setState(() {
          Provider.of<UserContext>(context, listen: false)
              .setUser(data['user']);
          Provider.of<TransactionContext>(context, listen: false)
              .setTransactions(data['transactions']);
          Provider.of<BeneficiaryContext>(context, listen: false)
              .setBeneficiaries(data['beneficiaries']);
        });

        if (!data['user']['is_verified']) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) =>
                  OTPValidationScreen(email: data['user']['email'])));
        }
      }, onError: (error) {
        if (error == 'Unauthorized') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginScreen()));
        } else {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => ErrorPage()));
        }
      });
    }

    return Expanded(
        child: RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
          itemCount: transactions!.length,
          itemBuilder: (_, index) => ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              TransactionDetailScreen(transactions[index])));
                },
                leading: Icon(Icons.folder),
                title: Text(transactions[index]['title']),
                subtitle: Text(
                    "Sent by " + transactions[index]['sender']['username']),
                trailing: Card(
                  elevation: 0,
                  color: transactions[index]['status'] == "Available"
                      ? Color(0xff6CC9E1)
                      : Colors.blueGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text("${transactions[index]['status']}"),
                  ),
                ),
              )),
    ));
  }
}
