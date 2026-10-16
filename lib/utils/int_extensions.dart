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

/// Formata a faixa de descanso (ex: `45 a 60s`, `2 a 3min`, `1min 30s`).
/// Retorna "Não definido" para exercícios salvos antes de o descanso existir.
String formatRestRange(int? min, int? max) {
  if (min == null || max == null) return 'Não definido';
  if (min == max) return min.restTime;
  if (min % 60 == 0 && max % 60 == 0) return '${min ~/ 60} a ${max ~/ 60}min';
  return '$min a ${max}s';
}
