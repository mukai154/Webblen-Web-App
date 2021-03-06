import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:webblen_web_app/firebase/data/webblen_user.dart';
import 'package:webblen_web_app/firebase/services/authentication.dart';
import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';
import 'package:webblen_web_app/widgets/common/navigation/nav_drawer/nav_drawer.dart';
import 'package:webblen_web_app/widgets/common/navigation/navigation_bar.dart';

class LayoutTemplate extends StatefulWidget {
  final Widget child;
  LayoutTemplate({this.child});
  @override
  _LayoutTemplateState createState() => _LayoutTemplateState();
}

class _LayoutTemplateState extends State<LayoutTemplate> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuthenticationService().userIsSignedIn();
  }

  navigateToHomePage() {
    if (scaffoldKey.currentState.isDrawerOpen) {
      scaffoldKey.currentState.openEndDrawer();
    }
    locator<NavigationService>().navigateTo(HomeRoute);
  }

  navigateToLoginPage() {
    if (scaffoldKey.currentState.isDrawerOpen) {
      scaffoldKey.currentState.openEndDrawer();
    }
    locator<NavigationService>().navigateTo(AccountLoginRoute);
  }

  navigateToEventsPage() {
    if (scaffoldKey.currentState.isDrawerOpen) {
      scaffoldKey.currentState.openEndDrawer();
    }
    locator<NavigationService>().navigateTo(EventsRoute);
  }

  navigateToWalletPage() {
    if (scaffoldKey.currentState.isDrawerOpen) {
      scaffoldKey.currentState.openEndDrawer();
    }
    locator<NavigationService>().navigateTo(WalletRoute);
  }

  navigateToAccountPage() {
    if (scaffoldKey.currentState.isDrawerOpen) {
      scaffoldKey.currentState.openEndDrawer();
    }
    locator<NavigationService>().navigateTo(AccountRoute);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    //FirebaseAuthenticationService().userIsSignedIn();
//    print(user.uid);
//    print(user.isAnonymous);

    return StreamProvider<WebblenUser>.value(
      value: user == null || user.isAnonymous ? null : WebblenUserData().streamCurrentUser(user.uid),
      child: ResponsiveBuilder(
        builder: (builderContext, sizingInfo) => Scaffold(
          key: scaffoldKey,
          drawer: sizingInfo.deviceScreenType == DeviceScreenType.Mobile
              ? NavDrawer(
                  authStatus: user == null ? "unknown" : user.isAnonymous ? "anonymous" : "loggedIn",
                  navigateToAccountLoginPage: () => navigateToLoginPage(),
                  navigateToEventsPage: () => navigateToEventsPage(),
                  navigateToWalletPage: () => navigateToWalletPage(),
                  navigateToAccountPage: () => navigateToAccountPage(),
                )
              : null,
          backgroundColor: Colors.transparent,
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                NavigationBar(
                  authStatus: user == null ? "unknown" : user.isAnonymous ? "anonymous" : "loggedIn",
                  openNavDrawer: () => scaffoldKey.currentState.openDrawer(),
                  navigateToHomePage: () => navigateToHomePage(),
                  navigateToAccountLoginPage: () => navigateToLoginPage(),
                  navigateToEventsPage: () => navigateToEventsPage(),
                  navigateToWalletPage: () => navigateToWalletPage(),
                  navigateToAccountPage: () => navigateToAccountPage(),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
