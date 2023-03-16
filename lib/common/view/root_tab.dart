import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/product/view/product_tab.dart';
import 'package:actual/restaurant/view/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with  SingleTickerProviderStateMixin{
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = TabController(length: 4, vsync: this);

    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    // TODO: implement dispose
    super.dispose();
  }

  void tabListener(){
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COlOR,
      title: '딜러버리',
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          RestaurantScreen(),
          ProductTab(),
          Container(
            child: Text('order'),
          ),
          Container(
            child: Text('profile'),
          ),
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COlOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.shifting,
        onTap: (int index){
          controller.animateTo(index);
        },
        currentIndex: controller.index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: 'food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'profile',
          ),
        ],
      ),
    );
  }
}
