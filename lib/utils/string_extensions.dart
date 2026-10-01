extension StringExtensions on String {
  String get title {
    if (isEmpty) return this;
    return split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
}

extension NumberParsing on String {
  /// Converte para inteiro, retornando `null` se o texto não for um número válido.
  int? toIntOrNull() => int.tryParse(trim());

  /// Converte para double aceitando vírgula ou ponto como separador decimal.
  double? toDoubleOrNull() => double.tryParse(trim().replaceAll(',', '.'));
}
