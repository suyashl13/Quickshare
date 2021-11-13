import 'package:flutter/material.dart';
import 'package:quickshare_client/config/Env.dart';

// ignore: must_be_immutable
class QuickBeneficiary extends StatelessWidget {
  Map beneficiaryDetails;
  QuickBeneficiary({Key? key, required this.beneficiaryDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: SizedBox(
        width: 99,
        height: 82,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xff6CC9E1),
                ),
                width: 98,
                height: 60,
                child: Column(
                  verticalDirection: VerticalDirection.up,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        "@" + beneficiaryDetails['beneficiary']['username'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Center(
                child: ClipOval(
                  child:
                      beneficiaryDetails['beneficiary']['profile_photo'] == null
                          ? Image.asset(
                              'assets/images/user.png',
                              height: 44,
                              width: 44,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              '${Env().BASE_URL + beneficiaryDetails['beneficiary']['profile_photo']}',
                              height: 44,
                              width: 44,
                              fit: BoxFit.cover,
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
