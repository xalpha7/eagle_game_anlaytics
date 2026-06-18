import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lila_black_analytics/AppSession.dart';
import 'package:lila_black_analytics/DashboardScreen.dart';
import 'package:lila_black_analytics/utils/StylishLoader.dart';

class StartPage extends StatelessWidget {
  AppSession appSession;
  StartPage({super.key, required this.appSession});

  ui() {
    return Obx(() {
      final controller = appSession.dashboardController;

      if (controller == null) {
        return StylishLoadingPage(appSession: appSession);
      }

      if (controller.displayDate.value.isEmpty) {
        return StylishLoadingPage(appSession: appSession);
      }

      return DashboardScreen(appSession: appSession);
    });
  }

  @override
  Widget build(BuildContext context) {
    // return StylishLoadingPage(appSession: appSession);
    return ui();
  }
}
