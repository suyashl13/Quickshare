import 'package:flutter/foundation.dart';

class BeneficiaryContext with ChangeNotifier {
  List? _beneficiaries;

  setBeneficiaries(List beneficiaries) {
    _beneficiaries = beneficiaries;
  }

  List? getBeneficiaries() => _beneficiaries;
}
