import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:restaurant_with_api/page/page_list_restaurant.dart';
import 'package:restaurant_with_api/page/page_settings.dart';

import '../component/notification_helper.dart';

class PageBottomBar extends StatefulWidget {
  static String routeName = '/bottom_bar';

  @override
  State<PageBottomBar> createState() => _PageBottomBarState();
}

class _PageBottomBarState extends State<PageBottomBar> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationHelper.configureSelectNotificationSubject(context);
  }

  PersistentTabController? _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [PageListRestaurants(), PageSettings()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.dashboard,
          size: 20,
        ),
        title: ("Dashboard"),
        activeColorPrimary: CupertinoColors.systemPink,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.settings,
          size: 20,
        ),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        confineInSafeArea: true,
        padding: NavBarPadding.all(0),
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          border: Border.all(color: Colors.grey.shade800),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style1, // Choose the nav bar style with this property.
      ),
    );
  }
}
