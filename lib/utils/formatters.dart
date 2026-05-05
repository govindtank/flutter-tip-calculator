import 'package:intl/intl.dart';
import '../models/models.dart';

class Formatters {
  static String formatCurrency(double amount, Currency currency) {
    final formatter = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: currency.decimalDigits,
    );
    return formatter.format(amount);
  }

  static String formatCurrencyCompact(double amount, Currency currency) {
    final formatter = NumberFormat('#,##0.${'0' * currency.decimalDigits}', 'en_US');
    final formattedNumber = formatter.format(amount);
    return '${currency.symbol}$formattedNumber';
  }

  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(percentage.truncateToDouble() == percentage ? 0 : 1)}%';
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM d, yyyy h:mm a').format(date);
  }

  static String formatNumber(double number, {int decimalDigits = 2}) {
    final formatter = NumberFormat('#,##0.${'0' * decimalDigits}', 'en_US');
    return formatter.format(number);
  }
}
