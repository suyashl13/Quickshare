import 'dart:convert';

import 'package:quickshare_client/config/Env.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BeneficiaryHelper {
  // ignore: non_constant_identifier_names
  String BASE_URL = Env().BASE_URL;
  late SharedPreferences _preferences;

  Future addBeneficiary({
    required onSuccess(res),
    required onError(err),
    required String username,
  }) async {
    _preferences = await SharedPreferences.getInstance();
    try {
      await http.post(Uri.parse(BASE_URL + 'api/v1/beneficiary'), headers: {
        'Authorization': _preferences.getString('token').toString()
      }, body: {
        'username': username
      }).then((res) {
        if (res.statusCode == 200) {
          onSuccess(jsonDecode(res.body));
        } else if (res.statusCode == 401) {
          throw "Unauthorized";
        } else {
          throw jsonDecode(res.body)['err'];
        }
      }).catchError((err) {
        throw err.toString();
      }).timeout(Duration(seconds: 40));
    } catch (e) {
      onError(e);
    }
  }

  Future searchBeneficiary(
      {required String searchQuery,
      required onSuccess(data),
      required onError(err)}) async {
    _preferences = await SharedPreferences.getInstance();
    try {
      await http.get(Uri.parse(BASE_URL + 'api/v1/beneficiary/' + searchQuery),
          headers: {
            'Authorization': _preferences.getString('token').toString()
          }).then((res) {
        if (res.statusCode == 200) {
          onSuccess(jsonDecode(res.body));
        } else if (res.statusCode == 401) {
          throw "Unauthorized";
        } else {
          throw jsonDecode(res.body)['err'];
        }
      }).catchError((err) {
        throw err.toString();
      }).timeout(Duration(seconds: 40));
    } catch (e) {
      onError(e);
    }
  }
}
