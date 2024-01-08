// ignore_for_file: library_private_types_in_public_api

import 'package:Green/Customer/home_page.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:Green/Green_Store/greenlab/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:Green/Green_Store/constants/constants.dart';
import 'package:Green/Green_Store/screens/cart_screen/cart_screen.dart';
import 'package:Green/Green_Store/screens/bottom_bar/widgets/notifications.dart';
import 'package:Green/Green_Store/screens/favorite_screen/favorite.dart';
import 'package:Green/Green_Store/screens/home/home.dart';
import 'package:Green/Green_Store/screens/order_screen/order_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _bottomNavIndex = 0;

  List<Widget> _widgetOptions() {
    return [
      const Home(),
      const FavouriteScreen(),
      const CartScreen(),
      const OrderScreen(),
    ];
  }

  List<IconData> iconList = [
    Icons.home,
    Icons.favorite,
    Icons.shopping_cart,
    Icons.receipt_long,
  ];

  List<String> titleList = [
    'Green Store',
    'Favorite',
    'Cart',
    'Orders',
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // statusBarColor: backgroundColor,
      systemNavigationBarColor: Colors.white,
    ));
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titleList[_bottomNavIndex],
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: const HomePage(),
                          type: PageTransitionType.bottomToTop,
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.black54,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _bottomNavIndex,
                children: _widgetOptions(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   PageTransition(
            //     child: const HomeScreen(),
            //     type: PageTransitionType.bottomToTop,
            //   ),
            // );
          },
          backgroundColor: Constants.primaryColor,
          child: Image.asset(
            'lib/Green_Store/assets/images/code-scan-two.png',
            height: 30.0,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          splashColor: Constants.primaryColor,
          activeColor: Constants.primaryColor,
          inactiveColor: Colors.black.withOpacity(.5),
          icons: iconList,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
            });
          },
        ),
      ),
    );
  }
}
