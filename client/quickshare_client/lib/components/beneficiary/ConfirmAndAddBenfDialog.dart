import 'package:flutter/material.dart';
import 'package:quickshare_client/helpers/BeneficiaryHelper.dart';

// ignore: must_be_immutable
class ConfirmAndAddBeneficiaryDialog extends StatelessWidget {
  String username;
  ConfirmAndAddBeneficiaryDialog({required this.username});

  _addBeneficiary(BuildContext context) async {
    await BeneficiaryHelper().addBeneficiary(
          onSuccess: (res) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Added new Beneficiary. Please refresh.")));
          },
          onError: (err) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(err),backgroundColor: Colors.red,));
          },
          username: this.username);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Alert"),
      content: Text("Are you sure want to add @${this.username} as beneficiary ?"),
      actions: [
        TextButton(onPressed: () {_addBeneficiary(context);}, child: Text("Yes")),
        TextButton(onPressed: () {Navigator.pop(context);}, child: Text("No")),
      ],
    );
  }
}
