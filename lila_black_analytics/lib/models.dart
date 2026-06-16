// lib/models.dart

class MatchStat {
  final String matchId;
  final String mapId;
  final int totalHumans;
  final int totalBots;
  final int kills;
  final int deaths;
  final int loots;
  final int stormDeaths;
  final int durationSeconds;

  MatchStat({
    required this.matchId,
    required this.mapId,
    required this.totalHumans,
    required this.totalBots,
    required this.kills,
    required this.deaths,
    required this.loots,
    required this.stormDeaths,
    required this.durationSeconds,
  });

  factory MatchStat.fromJson(Map<String, dynamic> json) {
    return MatchStat(
      matchId: json['match_id']?.toString() ?? '',
      mapId: json['map_id']?.toString() ?? 'Unknown',
      totalHumans: json['total_humans'] ?? 0,
      totalBots: json['total_bots'] ?? 0,
      kills: json['kills'] ?? 0,
      deaths: json['deaths'] ?? 0,
      loots: json['loots'] ?? 0,
      stormDeaths: json['storm_deaths'] ?? 0,
      durationSeconds: json['duration_seconds'] ?? 0,
    );
  }
}

class PlaybackEvent {
  final String userId;
  final bool isBot;
  final String eventType;
  final double pixelX;
  final double pixelY;
  final int timestampSeconds;

  PlaybackEvent({
    required this.userId,
    required this.isBot,
    required this.eventType,
    required this.pixelX,
    required this.pixelY,
    required this.timestampSeconds,
  });

  factory PlaybackEvent.fromJson(Map<String, dynamic> json) {
    return PlaybackEvent(
      userId: json['user_id']?.toString() ?? 'unknown',
      isBot: json['is_bot'] ?? false,
      eventType: json['event_type']?.toString() ?? 'Position',
      pixelX: (json['pixel_x'] ?? 0.0).toDouble(),
      pixelY: (json['pixel_y'] ?? 0.0).toDouble(),
      timestampSeconds: json['timestamp_seconds'] ?? 0,
    );
  }
}