import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'api_provider.dart';

// Selection States
final selectedMapProvider = StateProvider<String?>((ref) => null);
final selectedDateProvider = StateProvider<String?>((ref) => null);
final selectedMatchIdProvider = StateProvider<String?>((ref) => null);

// Data Fetchers
final mapsProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(telemetryRepositoryProvider).getMaps();
});

final datesProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(telemetryRepositoryProvider).getDates();
});

final matchesProvider = FutureProvider<List<String>>((ref) async {
  final mapId = ref.watch(selectedMapProvider);
  final date = ref.watch(selectedDateProvider);
  if (mapId == null || date == null) return [];
  return ref.watch(telemetryRepositoryProvider).getMatches(mapId: mapId, date: date);
});

// Match Specific Data
final matchStatsProvider = FutureProvider((ref) async {
  final matchId = ref.watch(selectedMatchIdProvider);
  if (matchId == null) throw Exception('No match selected');
  return ref.watch(telemetryRepositoryProvider).getStats(matchId);
});