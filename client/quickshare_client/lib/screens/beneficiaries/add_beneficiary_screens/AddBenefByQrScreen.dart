import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:quickshare_client/helpers/BeneficiaryHelper.dart';

class AddBenfByQrCodeScreen extends StatefulWidget {
  const AddBenfByQrCodeScreen({Key? key}) : super(key: key);

  @override
  _AddBenfByQrCodeScreenState createState() => _AddBenfByQrCodeScreenState();
}

class _AddBenfByQrCodeScreenState extends State<AddBenfByQrCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool _reqSent = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          (result != null) ? SizedBox() : LinearProgressIndicator(),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'QR Found')
                  : Text('Looking for QR Code of Beneficiary.'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      _addBeneficiaryOnFound(scanData.code!);
    });
  }

  _addBeneficiaryOnFound(String username) async {
    if (!_reqSent) {
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
          username: username);
      setState(() {
        _reqSent = true;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
