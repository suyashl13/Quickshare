import 'dart:convert';

import 'package:quickshare_client/config/Env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeHelper {
  final String BASE_URL = Env().BASE_URL;
  late SharedPreferences _localStorage;

  Future getHomeData({required onSuccess(data), required onError(err)}) async {
    _localStorage = await SharedPreferences.getInstance();

    if (_localStorage.getString('token') == null) {
      onError("Unauthorized");
      return;
    }

    try {
      await http.get(Uri.parse('${BASE_URL}api/v1/profile'), headers: {
        'Authorization': _localStorage.getString('token').toString()
      }).then((res) {
        if (res.statusCode == 200) {
          onSuccess(jsonDecode(res.body));
        } else if (res.statusCode == 401) {
          onError('Unauthorized');
        } else {
          throw jsonDecode(res.body)['err'];
        }
      }).timeout(Duration(seconds: 30));
    } catch (e) {
      onError(e);
    }
  }
}
