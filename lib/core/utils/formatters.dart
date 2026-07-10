String formatCurrencyBRL(double value) {
  final isNegative = value < 0;
  final absValue = value.abs();
  final parts = absValue.toStringAsFixed(2).split('.');
  final intPart = parts[0];
  final decPart = parts[1];

  final buffer = StringBuffer();
  for (var i = 0; i < intPart.length; i++) {
    if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write('.');
    buffer.write(intPart[i]);
  }

  return '${isNegative ? '-' : ''}R\$${buffer.toString()},$decPart';
}

const _monthAbbreviations = [
  'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
  'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
];

String formatMonthYear(DateTime date) {
  return '${_monthAbbreviations[date.month - 1]} ${date.year}';
}