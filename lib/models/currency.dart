class Currency {
  final String code;
  final String symbol;
  final String name;
  final int decimalDigits;

  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.decimalDigits,
  });

  static const List<Currency> all = [
    Currency(code: 'USD', symbol: '\$', name: 'US Dollar', decimalDigits: 2),
    Currency(code: 'EUR', symbol: '€', name: 'Euro', decimalDigits: 2),
    Currency(code: 'GBP', symbol: '£', name: 'British Pound', decimalDigits: 2),
    Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee', decimalDigits: 2),
    Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen', decimalDigits: 0),
    Currency(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar', decimalDigits: 2),
    Currency(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar', decimalDigits: 2),
    Currency(code: 'BRL', symbol: 'R\$', name: 'Brazilian Real', decimalDigits: 2),
    Currency(code: 'MXN', symbol: '\$', name: 'Mexican Peso', decimalDigits: 2),
  ];

  static Currency fromCode(String code) {
    return all.firstWhere(
      (c) => c.code == code,
      orElse: () => all.first,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Currency && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}
