import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../repositories/telemetry_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final telemetryRepositoryProvider = Provider<TelemetryRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TelemetryRepository(apiClient);
});