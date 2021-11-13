import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:quickshare_client/config/Env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthHelper {
  // ignore: non_constant_identifier_names
  final String BASE_URL = Env().BASE_URL;
  late SharedPreferences _localStorage;

  Future loginAtBackend(
      {required onSuccess(data),
      required onError(err),
      required Map credentials}) async {
    _localStorage = await SharedPreferences.getInstance();

    try {
      await http
          .post(Uri.parse("${BASE_URL}api/v1/auth/login"),
              body: credentials,
              headers: {"Content-Type": "application/x-www-form-urlencoded"},
              encoding: Encoding.getByName('utf-8'))
          .then((res) {
        if (res.statusCode == 200) {
          Map response = jsonDecode(res.body);
          _localStorage.setString('token', response['token']);
          _localStorage.setString('email', response['user']['email']);
          _localStorage.setString('name', response['user']['name']);
          onSuccess(jsonDecode(res.body));
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

  Future createAccountAtBackend(
      {required onSuccess(data),
      required onError(err),
      required Map profileDetails,
      required File? profilePicture}) async {
    final FormData _profileFormData = FormData.fromMap({
      ...profileDetails,
      'profile_photo': profilePicture == null
          ? null
          : await MultipartFile.fromFile(
              profilePicture.path,
            ),
    });

    try {
      await Dio()
          .post("${BASE_URL}api/v1/profile",
              data: _profileFormData,
              options: Options(
                followRedirects: false,
                validateStatus: (int? status) {
                  return status! < 500;
                },
              ))
          .then((res) {
        if (res.statusCode == 200) {
          onSuccess(res.data);
        } else {
          throw res.data['err'];
        }
      }).catchError((err) {
        throw err.toString();
      });
    } catch (e) {
      onError(e);
    }
  }

  Future requestAccountVerificationAtBackend(
      {required onSuccess(res), required onError(err)}) async {
    _localStorage = await SharedPreferences.getInstance();
    try {
      http.get(
        Uri.parse("${BASE_URL}api/v1/auth/generateOTPSession"),
        headers: {'Authorization': _localStorage.getString('token').toString()},
      ).then((res) {
        if (res.statusCode == 200) {
          onSuccess(jsonDecode(res.body));
        } else {
          onError(jsonDecode(res.body)['err']);
        }
      }).catchError((err) {
        throw err;
      });
    } catch (e) {
      onError(e);
    }
  }

  Future verifyWithOTP(
      {required String otp,
      required onSuccess(res),
      required onError(err)}) async {
    _localStorage = await SharedPreferences.getInstance();
    try {
      http
          .post(Uri.parse("${BASE_URL}api/v1/auth/verifyAccount"),
              headers: {
                'Authorization': _localStorage.getString('token').toString(),
                "Content-Type": "application/x-www-form-urlencoded"
              },
              body: {'otp': otp},
              encoding: Encoding.getByName('utf-8'))
          .then((res) {
        if (res.statusCode == 200) {
          onSuccess(jsonDecode(res.body));
        } else {
          onError(jsonDecode(res.body)['err']);
        }
      });
    } catch (e) {
      onError(e);
    }
  }
}
