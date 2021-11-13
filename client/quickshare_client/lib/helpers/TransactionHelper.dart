import 'dart:io';

import 'package:dio/dio.dart';
import 'package:quickshare_client/config/Env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionHelper {
  String BASE_URL = Env().BASE_URL;
  late SharedPreferences _preferences;

  Future sendTransactionFile(
      {required onSuccess(data),
      required onError(err),
      required onProgress(int sent, int total),
      required Map transactionDetails,
      required File transactionFile}) async {
    _preferences = await SharedPreferences.getInstance();
    final FormData _transactionDetails = FormData.fromMap({
      ...transactionDetails,
      'transaction_file': await MultipartFile.fromFile(
        transactionFile.path,
      ),
    });

    try {
      await Dio()
          .post("${BASE_URL}api/v1/transactions",
              data: _transactionDetails,
              onSendProgress: onProgress,
              options: Options(
                headers: {
                  'Authorization': _preferences.getString('token').toString()
                },
                followRedirects: false,
                validateStatus: (int? status) {
                  return status! < 500;
                },
              ))
          .then((res) {
        if (res.statusCode == 200) {
          onSuccess(res.data);
        } else {
          throw res.data;
        }
      }).catchError((err) {
        throw err.toString();
      });
    } catch (e) {
      onError(e);
    }
  }
}
