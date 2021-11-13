import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickshare_client/contexts/BeneficiaryContext.dart';
import 'package:quickshare_client/screens/beneficiaries/BeneficiaryScreen.dart';
import 'package:quickshare_client/screens/home/HomeScreen.dart';
import 'package:quickshare_client/screens/transactions/NewTransactionScreen.dart';

class BottomNavigationContainer extends StatefulWidget {
  const BottomNavigationContainer({Key? key}) : super(key: key);

  @override
  _BottomNavigationContainerState createState() =>
      _BottomNavigationContainerState();
}

class _BottomNavigationContainerState extends State<BottomNavigationContainer> {
  int _activePage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: IndexedStack(
        index: _activePage,
        children: [
          HomeScreen(),
          BeneficiaryScreen(),
        ],
      )),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff6CC9E1),
          child: Icon(Icons.send),
          elevation: 1.4,
          onPressed: () {
            List? beneficiaries =
                Provider.of<BeneficiaryContext>(context, listen: false).getBeneficiaries();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    NewTransactionScreen(beneficiaries: beneficiaries!)));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black38,
        selectedItemColor: Color(0xff6CC9E1),
        currentIndex: _activePage,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: "Beneficiaries"),
        ],
        onTap: (int index) {
          setState(() {
            _activePage = index;
          });
        },
      ),
    );
  }
}
