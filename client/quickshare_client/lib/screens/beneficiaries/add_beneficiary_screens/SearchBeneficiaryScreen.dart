import 'package:flutter/material.dart';
import 'package:quickshare_client/components/beneficiary/AddBeneficiaryDialog.dart';
import 'package:quickshare_client/components/beneficiary/ConfirmAndAddBenfDialog.dart';
import 'package:quickshare_client/config/Env.dart';
import 'package:quickshare_client/helpers/BeneficiaryHelper.dart';

class SearchBeneficiaryScreen extends StatefulWidget {
  const SearchBeneficiaryScreen({Key? key}) : super(key: key);

  @override
  _SearchBeneficiaryScreenState createState() =>
      _SearchBeneficiaryScreenState();
}

class _SearchBeneficiaryScreenState extends State<SearchBeneficiaryScreen> {
  bool _isLoading = false;
  List _queryResult = [];

  Future _searchQuery(String qString) async {
    setState(() {
      _isLoading = true;
    });
    if (qString == '') {
      setState(() {
        _queryResult = [];
        _isLoading = false;
      });
      return;
    }
    await BeneficiaryHelper().searchBeneficiary(
        searchQuery: qString.trim(),
        onSuccess: (res) {
          setState(() {
            _queryResult = res;
            _isLoading = false;
          });
        },
        onError: (err) {
          setState(() {
            _queryResult = [];
            _isLoading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(err)));
        });
  }

  _addBenf(String username) async {
    return await showDialog(
        context: context,
        builder: (context) =>
            ConfirmAndAddBeneficiaryDialog(username: username));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Search\nBeneficiaries",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color.fromRGBO(47, 47, 47, 1)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 14),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xff6CC9E1)),
                  child: TextFormField(
                    onChanged: (String? val) async {
                      _searchQuery(val!);
                    },
                    decoration: InputDecoration.collapsed(hintText: "Search"),
                  ),
                ),
                Divider(height: 14),
                Expanded(
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: _queryResult.length,
                            itemBuilder: (context, index) => ListTile(
                              leading:
                                  _queryResult[index]['profile_photo'] == null
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
                                            '${Env().BASE_URL + _queryResult[index]['profile_photo']}',
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                              onTap: () {
                                _addBenf(_queryResult[index]['username']);
                              },
                              title: Text(_queryResult[index]['name']),
                              subtitle:
                                  Text("@" + _queryResult[index]['username']),
                            ),
                          ))
              ],
            ),
          ),
        ),
      );
}
