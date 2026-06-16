import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import 'websocket_service.dart';
import 'views/dashboard_screen.dart';

void main() {
  // Dependency Injection setup via GetX
  Get.put(DashboardController());
  final wsService = Get.put(WebsocketService());

  // Establish connection on app start
  // wsService.connect();

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
