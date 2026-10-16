extension RestTimeFormatting on int {
  /// Formata segundos de descanso para exibição (ex: `45s`, `2min`, `1min 30s`).
  String get restTime {
    final int minutes = this ~/ 60;
    final int seconds = this % 60;

    if (minutes == 0) return '${seconds}s';
    if (seconds == 0) return '${minutes}min';
    return '${minutes}min ${seconds}s';
  }
}
