import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lila_black_analytics/DashboardController.dart';
import 'package:lila_black_analytics/DashboardScreen.dart';
import 'websocket_service.dart';

void main() {
  // Dependency Injection setup via GetX

  final wsService = Get.put(WebsocketService(), permanent: true);
  Get.lazyPut(() => DashboardController(wsSocket: wsService), fenix: true);

  // Establish connection on app start
  wsService.connect();

  runApp(const LILABlackApp());
}

class LILABlackApp extends StatelessWidget {
  const LILABlackApp({Key? key}) : super(key: key);

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
      home: DashboardScreen(),
    );
  }
}
