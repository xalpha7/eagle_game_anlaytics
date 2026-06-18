import 'package:lila_black_analytics/DashboardController.dart';
import 'package:lila_black_analytics/websocket_service.dart';

class AppSession {
  late DashboardController dashboardController;
  late WebsocketService websocketService;
  String appName = "Gameplay Analytics";
  String appIcon = "assets/icon/Icon-512.png";
}
