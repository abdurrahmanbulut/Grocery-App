import 'package:flutter/material.dart';
import 'package:grocery_app/model/data_model.dart';
import 'package:grocery_app/model/user.dart';
import 'package:grocery_app/screens/cashier_addpoint_screen.dart';
import 'package:grocery_app/screens/cashier_order_screen.dart';
import 'package:grocery_app/screens/cashier_search_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/screens/cashier_qr_scan_screen.dart';

class CashierHomeScreen extends StatefulWidget {
  final List<CategoryProduct> categories;
  final List<Order> orders;
  final List<Order> TodaysOrders;
  const CashierHomeScreen(this.categories, this.orders, this.TodaysOrders,
      {Key? key})
      : super(key: key);

  @override
  _CashierHomeScreenState createState() => _CashierHomeScreenState();
}

class _CashierHomeScreenState extends State<CashierHomeScreen> {
  int _selectedIndex = 0;
  PageController pageController = PageController();
  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    @override
    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Emin misiniz?'),
              content: new Text('Uygulamadan çıkmak istiyor musunuz?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('Hayır'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Evet'),
                ),
              ],
            ),
          )) ??
          false;
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QRScreenWidget(
                          allOrders: widget.orders,
                        )));
              },
              icon: Icon(Icons.qr_code_2_outlined),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => LoginScreen(widget.categories)));
                },
              )
            ],
            elevation: 0,
            backgroundColor: Colors.amber,
            title: const Text('GROCERY',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'YOUR_FONT_FAMILY')),
            centerTitle: true,
          ),
          body: PageView(
            controller: pageController,
            children: [
              Container(child: CashierOrderScreen(widget.TodaysOrders)),
              Container(child: CashierSearchPage(widget.orders)),
              Container(child: AddPointPage()),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Ara'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_rounded),
                  label: 'Para Ekle'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.black,
            onTap: onTapped,
          ),
        ));
  }
}
