import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lila_black_analytics/AppSession.dart';
import 'package:lila_black_analytics/DashboardController.dart';
import 'package:lila_black_analytics/DashboardScreen.dart';
import 'package:lila_black_analytics/StartPage.dart';
import 'websocket_service.dart';

void main() {
  // Dependency Injection setup via GetX
  AppSession appSession = new AppSession();
  // Get.put(DashboardController());
  final websocketService = Get.put(WebsocketService(appSession: appSession));
  final dashcontroller = Get.put(DashboardController(appSession: appSession));
  appSession.dashboardController = dashcontroller;
  appSession.websocketService = websocketService;
  // Establish connection on app start
  // wsService.connect();

  runApp(LILABlackApp(appSession: appSession));
}

class LILABlackApp extends StatelessWidget {
  AppSession appSession;
  LILABlackApp({Key? key, required this.appSession}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LILA BLACK Analytics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
      ),
      home: StartPage(appSession: appSession),
    );
  }
}
