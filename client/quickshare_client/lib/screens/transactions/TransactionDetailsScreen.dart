import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickshare_client/config/Env.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class TransactionDetailScreen extends StatefulWidget {
  Map transactionDetails;
  TransactionDetailScreen(this.transactionDetails);

  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState(this.transactionDetails);
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  Map transactionDetails;
  _TransactionDetailScreenState(this.transactionDetails);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "File\nTransaction",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color.fromRGBO(47, 47, 47, 1)),
                ),
                Card(
                  color: transactionDetails['status'] == "Available"
                      ? Color(0xff6CC9E1)
                      : Colors.blueGrey,
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      "${transactionDetails['status']}",
                      style: TextStyle(
                          fontSize: 14, color: Color.fromRGBO(47, 47, 47, 1)),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 18),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff479FBE), Color(0xff6CC9E1)]),
                  borderRadius: BorderRadius.circular(6)),
              padding: EdgeInsets.symmetric(horizontal: 14),
              width: double.maxFinite,
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transactionDetails['title'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  Text(
                    DateFormat.yMMMd().format(
                        DateTime.parse(transactionDetails['createdAt'])),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black45),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "From,",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromRGBO(47, 47, 47, 1)),
                            ),
                            Text(
                              transactionDetails['sender']['name'],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(47, 47, 47, 1)),
                            ),
                            Text(
                              "(@${transactionDetails['sender']['username']})",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(47, 47, 47, 1)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "To,",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromRGBO(47, 47, 47, 1)),
                            ),
                            Text(transactionDetails['reciever']['name'],
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(47, 47, 47, 1))),
                            Text(
                                "(@${transactionDetails['reciever']['username']})\n",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(47, 47, 47, 1))),
                          ],
                        ),
                      ),
                      Divider(thickness: 0.8),
                      Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color.fromRGBO(47, 47, 47, 1)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                            "${transactionDetails['description'] == null ? "No Description" : transactionDetails['description']}"),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      transactionDetails['is_expired']
                          ? SizedBox()
                          : Container(
                              width: double.maxFinite,
                              child: MaterialButton(
                                textColor: Colors.white,
                                elevation: 0.1,
                                onPressed: () async {
                                  String url = Env().BASE_URL +
                                      transactionDetails['file_path'];
                                  try {
                                    await launch(url);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Opps! Something went wrong..")));
                                  }
                                },
                                color: Color(0xff479FBE),
                                child: Text("Download File"),
                              ),
                            ),
                      Container(
                        width: double.maxFinite,
                        child: MaterialButton(
                          textColor: Colors.white,
                          elevation: 0.1,
                          onPressed: () => Navigator.pop(context),
                          color: Color(0xffE99292),
                          child: Text("Go Back"),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
