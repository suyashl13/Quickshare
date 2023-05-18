import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quickshare_client/helpers/AuthHelper.dart';
import 'package:quickshare_client/screens/auth/LoginScreen.dart';
import 'package:string_validator/string_validator.dart';

class CreateAccountForm extends StatefulWidget {
  const CreateAccountForm({Key? key}) : super(key: key);

  @override
  _CreateAccountFormState createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map newProfileDetails = {
    'name': '',
    'email': '',
    'username': '',
    'birth_year': 0,
    'password': '',
    'profile_picture': '',
  };
  File? file;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            // ignore: unnecessary_null_comparison
            GestureDetector(
              onTap: () async {
                FilePickerResult? _result =
                    await FilePicker.platform.pickFiles(type: FileType.image);
                if (_result != null) {
                  setState(() {
                    file = File(_result.files.single.path.toString());
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No File Selected")));
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                child: Column(
                  children: [
                    file == null
                        ? ClipOval(
                            child: Image.asset(
                              'assets/images/user.png',
                              fit: BoxFit.cover,
                              height: 120,
                              width: 120,
                            ),
                          )
                        : ClipOval(
                            child: Image.file(
                              file!,
                              fit: BoxFit.cover,
                              height: 120,
                              width: 120,
                            ),
                          ),
                    Text("\nChange Profile")
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.only(bottom: 0, left: 12, right: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    child: Center(
                        child: TextFormField(
                      validator: (String? val) {
                        if ((val!.length <= 2) && (val.split(' ').length > 0)) {
                          return 'Invalid first name';
                        }
                      },
                      onSaved: (i) {
                        setState(() {
                          newProfileDetails['name'] = i!.trim();
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "First Name", border: InputBorder.none),
                    )),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.only(bottom: 0, left: 12, right: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    child: Center(
                        child: TextFormField(
                      validator: (String? val) {
                        if ((val!.length <= 2) && (val.split(' ').length > 0)) {
                          return 'Invalid last name';
                        }
                      },
                      onSaved: (i) {
                        setState(() {
                          newProfileDetails['name'] =
                              newProfileDetails['name'] + ' ' + i!.trim();
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Last Name", border: InputBorder.none),
                    )),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.only(bottom: 0, left: 12, right: 12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
              child: Center(
                  child: TextFormField(
                validator: (val) {
                  if ((!val!.contains('@')) && (!val.contains('.'))) {
                    return 'Invalid email.';
                  }
                },
                onSaved: (val) {
                  setState(() {
                    newProfileDetails['email'] = val!.trim();
                  });
                },
                decoration: InputDecoration(
                    hintText: "Email", border: InputBorder.none),
              )),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.only(bottom: 0, left: 12, right: 12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
              child: Center(
                  child: TextFormField(
                validator: (val) {
                  if (!isAlphanumeric(val!)) {
                    return "Invalid username";
                  }
                  if (val.length == 0) {
                    return "Required";
                  }
                },
                onSaved: (val) {
                  setState(() {
                    newProfileDetails['username'] = val!.trim();
                  });
                },
                decoration: InputDecoration(
                    hintText: "Username", border: InputBorder.none),
              )),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.only(bottom: 0, left: 12, right: 12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
              child: Center(
                  child: TextFormField(
                validator: (val) {
                  if (val!.length != 4) {
                    return 'Invalid birth year.';
                  }
                },
                onSaved: (val) {
                  newProfileDetails['birth_year'] = val!.trim();
                },
                decoration: InputDecoration(
                    hintText: "Birth Year", border: InputBorder.none),
              )),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.only(bottom: 0, left: 12, right: 12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
              child: Center(
                  child: TextFormField(
                validator: (val) {
                  if (val!.trim().length < 6) {
                    return "Password should be longer than 6 chars.";
                  }
                },
                onChanged: (i) {
                  setState(() {
                    newProfileDetails['password'] = i;
                  });
                },
                onSaved: (val) {
                  newProfileDetails['password'] = val!.trim();
                },
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password", border: InputBorder.none),
              )),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.only(bottom: 0, left: 12, right: 12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
              child: Center(
                  child: TextFormField(
                validator: (val) {
                  if (newProfileDetails['password'] != val) {
                    return "Password did'nt match.";
                  }
                },
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Confirm Password", border: InputBorder.none),
              )),
            ),
            Container(
              margin: EdgeInsets.only(top: 12),
              width: double.maxFinite,
              child: MaterialButton(
                  child: Text(
                    'CREATE AN ACCOUNT',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                  elevation: 0,
                  color: Color(0xff479FBE),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await AuthHelper().createAccountAtBackend(
                          onSuccess: (data) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => LoginScreen(data['email'],
                                    newProfileDetails['password'])));
                          },
                          onError: (err) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(err),
                                backgroundColor: Colors.red));
                          },
                          profileDetails: newProfileDetails,
                          profilePicture: file);
                    }
                  }),
            ),
          ],
        ));
  }
}
