import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quickshare_client/helpers/TransactionHelper.dart';

// ignore: must_be_immutable
class NewTransactionScreen extends StatefulWidget {
  List beneficiaries;
  NewTransactionScreen({required this.beneficiaries});

  @override
  _NewTransactionScreenState createState() =>
      _NewTransactionScreenState(this.beneficiaries);
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  TextEditingController _controller = TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Map _transactionDetails = {
    'title': '',
    'description': '',
    'receiver': null,
  };

  File? transactionFile;

  bool _isCustomUsername = true;
  List _beneficiaries;
  _NewTransactionScreenState(this._beneficiaries);
  bool _isLoadingLocally = false;

  Future<void> _uploadFileFromLocalStorage() async {
    setState(() {
      _isLoadingLocally = true;
    });
    FilePickerResult? filePickerResult = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: false);

    setState(() {
      _isLoadingLocally = false;
    });
    if (filePickerResult == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No file selected")));
    } else {
      setState(() {
        _isLoadingLocally = false;
        transactionFile = File(filePickerResult.files.single.path.toString());
      });
    }
  }

  double _fileUploadProgress = 0;
  bool _isUploadingFile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Send new\nFile",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color.fromRGBO(47, 47, 47, 1)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 18, bottom: 16),
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
                        transactionFile == null
                            ? "Upload a file"
                            : 'File uploaded',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      _isLoadingLocally
                          ? SizedBox(
                              child: CircularProgressIndicator(),
                              width: 12,
                              height: 12,
                            )
                          : GestureDetector(
                              onTap: _uploadFileFromLocalStorage,
                              child: Icon(
                                Icons.folder,
                                color: Colors.white,
                              ),
                            )
                    ],
                  ),
                ),
                Text(
                  "Details",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding:
                              EdgeInsets.only(bottom: 0, left: 14, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xff6CC9E1)),
                          child: TextFormField(
                            onSaved: (String? val) {
                              setState(() {
                                _transactionDetails['title'] = val!;
                              });
                            },
                            maxLength: 35,
                            validator: (String? val) {
                              if (val!.length == 0) {
                                return "Required.";
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Title for file",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding:
                              EdgeInsets.only(bottom: 0, left: 14, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xff6CC9E1)),
                          child: TextFormField(
                            maxLines: 3,
                            onChanged: (val) {
                              setState(() {
                                _transactionDetails['description'] = val;
                              });
                            },
                            maxLength: 134,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Description",
                            ),
                          ),
                        ),
                        Text(
                          "Send to",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 6),
                          padding:
                              EdgeInsets.only(bottom: 0, left: 14, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xff6CC9E1)),
                          child: TextFormField(
                            controller: _controller,
                            onChanged: (String? e) {
                              setState(() {
                                _isCustomUsername = true;
                                _transactionDetails['receiver'] = e;
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Username",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: Text("Or"),
                          ),
                        ),
                        Container(
                            width: double.maxFinite,
                            padding:
                                EdgeInsets.only(bottom: 0, left: 14, right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0xff6CC9E1)),
                            child: DropdownButton<String>(
                                value: _isCustomUsername
                                    ? null
                                    : _transactionDetails['receiver'],
                                hint: Text("Select user from beneficiary list"),
                                onChanged: (e) {
                                  setState(() {
                                    _isCustomUsername = false;
                                    _controller.clear();
                                    _transactionDetails['receiver'] = e;
                                  });
                                },
                                items: [
                                  ..._beneficiaries.map((e) => DropdownMenuItem(
                                      value: e['beneficiary']['username'],
                                      child: Text(
                                          "${e['beneficiary']['username']}")))
                                ])),
                        _isUploadingFile
                            ? Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: LinearProgressIndicator(
                                  value: _fileUploadProgress,
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 20),
                                width: double.maxFinite,
                                child: MaterialButton(
                                    color: Colors.blue[300],
                                    child: Text("Send "),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        if (_transactionDetails['receiver'] ==
                                            null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Username is required field.")));
                                          return;
                                        }
                                        if (transactionFile == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Please select a file to transfer.")));
                                          return;
                                        }
                                        setState(() {
                                          _isUploadingFile = true;
                                        });
                                        await TransactionHelper()
                                            .sendTransactionFile(
                                                onSuccess: (data) {
                                                  setState(() {
                                                    _isUploadingFile = false;
                                                  });
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "File Successfully Uploaded! Please Refresh.")));
                                                },
                                                onError: (err) {
                                                  setState(() {
                                                    _isUploadingFile = false;
                                                  });
                                                },
                                                onProgress: (progress, total) {
                                                  setState(() {
                                                    _fileUploadProgress =
                                                        progress / total;
                                                  });
                                                },
                                                transactionDetails:
                                                    _transactionDetails,
                                                transactionFile:
                                                    transactionFile!);
                                      }
                                    }),
                              )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
