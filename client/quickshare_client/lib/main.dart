import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickshare_client/AuthWrapper.dart';
import 'package:quickshare_client/contexts/BeneficiaryContext.dart';
import 'package:quickshare_client/contexts/TransactionContext.dart';
import 'package:quickshare_client/contexts/UserContext.dart';
import 'package:quickshare_client/screens/BottomNavigationContainer.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BeneficiaryContext()),
      ChangeNotifierProvider(create: (_) => UserContext()),
      ChangeNotifierProvider(create: (_) => TransactionContext()),

      // Providers
      Provider(create: (_) => AuthWrapper()),
      Provider(create: (_) => BottomNavigationContainer()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quickshare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Gilroy',
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(),
    );
  }
}
