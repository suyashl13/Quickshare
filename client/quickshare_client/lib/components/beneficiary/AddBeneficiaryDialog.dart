import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickshare_client/screens/beneficiaries/add_beneficiary_screens/AddBenefByQrScreen.dart';
import 'package:quickshare_client/screens/beneficiaries/add_beneficiary_screens/SearchBeneficiaryScreen.dart';

// ignore: must_be_immutable
class AddBeneficiaryDialog extends StatelessWidget {
  String username;

  AddBeneficiaryDialog(this.username);

  _showSelfQRCode(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Add a Beneficiary",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff6CC9E1)),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                      height: 200,
                      width: 200,
                      child: QrImage(data: this.username)),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "  Add a Beneficiary",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xff6CC9E1)),
          ),
        ),
        SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.qr_code),
          title: Text("Show Code"),
          onTap: () async {
            await _showSelfQRCode(context);
          },
          subtitle: Text("Scan the QR to add you as beneficiary."),
        ),
        ListTile(
          leading: Icon(Icons.qr_code_scanner_outlined),
          title: Text("Scan Code"),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => AddBenfByQrCodeScreen())),
          subtitle: Text("Open scanner to add beneficiary."),
        ),
        ListTile(
          leading: Icon(Icons.search),
          title: Text("Search"),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => 
            SearchBeneficiaryScreen())),
          subtitle: Text("Search username to add beneficiary."),
        ),
      ],
    );
  }
}
