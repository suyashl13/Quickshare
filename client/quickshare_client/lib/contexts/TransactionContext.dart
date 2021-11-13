import 'package:flutter/foundation.dart';

class TransactionContext with ChangeNotifier {
  List? _transactions;

  setTransactions(List transactions) async {
    _transactions = transactions;
  }

  getTransactions() => _transactions;
}
