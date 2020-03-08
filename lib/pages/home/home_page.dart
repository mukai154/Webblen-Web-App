import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'desktop/desktop_home_body.dart';
import 'mobile/mobile_home_body.dart';
import 'tablet/tablet_home_body.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: DesktopHomeBody(),
      tablet: TabletHomeBody(),
      mobile: MobileHomeBody(),
    );
  }
}
