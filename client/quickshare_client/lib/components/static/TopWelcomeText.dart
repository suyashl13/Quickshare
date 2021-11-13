import 'package:flutter/material.dart';

class TopWelcomeText extends StatelessWidget {
  const TopWelcomeText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to",
          style: TextStyle(fontSize: 16, color: Color.fromRGBO(47, 47, 47, 1)),
        ),
        Text(
          "Quickshare",
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color.fromRGBO(47, 47, 47, 1)),
        )
      ],
    );
  }
}
