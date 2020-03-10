import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/extensions/hover_extensions.dart';
import 'package:webblen_web_app/styles/custom_colors.dart';

import 'nav_bar_logo.dart';
import 'nav_item.dart';

class NavigationBar extends StatelessWidget {
  final bool isSignedIn;
  final VoidCallback openNavDrawer;
  final VoidCallback navigateToAccountLoginPage;
  final VoidCallback navigateToHomePage;
  final VoidCallback navigateToEventsPage;
  final VoidCallback navigateToWalletPage;
  final VoidCallback navigateToAccountPage;

  NavigationBar({
    this.isSignedIn,
    this.openNavDrawer,
    this.navigateToAccountLoginPage,
    this.navigateToHomePage,
    this.navigateToAccountPage,
    this.navigateToEventsPage,
    this.navigateToWalletPage,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: NavigationBarTabletDesktop(
        isSignedIn: isSignedIn,
        navigateToAccountLoginPage: navigateToAccountLoginPage,
        navigateToHomePage: navigateToHomePage,
        navigateToAccountPage: navigateToAccountPage,
        navigateToEventsPage: navigateToEventsPage,
        navigateToWalletPage: navigateToWalletPage,
      ),
      tablet: NavigationBarTabletDesktop(
        isSignedIn: isSignedIn,
        navigateToAccountLoginPage: navigateToAccountLoginPage,
        navigateToHomePage: navigateToHomePage,
        navigateToAccountPage: navigateToAccountPage,
        navigateToEventsPage: navigateToEventsPage,
        navigateToWalletPage: navigateToWalletPage,
      ),
      mobile: NavigationBarMobile(
        isSignedIn: isSignedIn,
        openNavDrawer: openNavDrawer,
        navigateToAccountLoginPage: navigateToAccountLoginPage,
        navigateToHomePage: navigateToHomePage,
        navigateToAccountPage: navigateToAccountPage,
        navigateToEventsPage: navigateToEventsPage,
        navigateToWalletPage: navigateToWalletPage,
      ),
    );
  }
}

class NavigationBarTabletDesktop extends StatelessWidget {
  final bool isSignedIn;
  final VoidCallback navigateToAccountLoginPage;
  final VoidCallback navigateToHomePage;
  final VoidCallback navigateToEventsPage;
  final VoidCallback navigateToWalletPage;
  final VoidCallback navigateToAccountPage;

  NavigationBarTabletDesktop({
    this.isSignedIn,
    this.navigateToAccountLoginPage,
    this.navigateToHomePage,
    this.navigateToAccountPage,
    this.navigateToEventsPage,
    this.navigateToWalletPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: navigateToHomePage,
            child: NavBarLogo(),
          ).showCursorOnHover,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              NavItem(
                onTap: navigateToEventsPage,
                title: "Events",
                color: Colors.black,
              ).showCursorOnHover,
              NavItem(
                onTap: navigateToWalletPage,
                title: "Wallet",
                color: Colors.black,
              ).showCursorOnHover,
              NavItem(
                onTap: navigateToAccountLoginPage,
                title: "Login",
                color: CustomColors.webblenRed,
              ).showCursorOnHover,
            ],
          ),
        ],
      ),
    );
  }
}

class NavigationBarMobile extends StatelessWidget {
  final bool isSignedIn;
  final VoidCallback openNavDrawer;
  final VoidCallback navigateToAccountLoginPage;
  final VoidCallback navigateToHomePage;
  final VoidCallback navigateToEventsPage;
  final VoidCallback navigateToWalletPage;
  final VoidCallback navigateToAccountPage;

  NavigationBarMobile({
    this.isSignedIn,
    this.openNavDrawer,
    this.navigateToAccountLoginPage,
    this.navigateToHomePage,
    this.navigateToAccountPage,
    this.navigateToEventsPage,
    this.navigateToWalletPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: openNavDrawer,
            icon: Icon(FontAwesomeIcons.bars, color: Colors.black, size: 24.0),
          ).showCursorOnHover,
          GestureDetector(
            onTap: navigateToHomePage,
            child: NavBarLogo(),
          ).showCursorOnHover,
        ],
      ),
    );
  }
}
