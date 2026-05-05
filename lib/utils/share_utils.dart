import 'package:share_plus/share_plus.dart';
import '../models/models.dart';
import 'formatters.dart';

class ShareUtils {
  static Future<void> shareCalculation(TipCalculation calculation, Currency currency) async {
    final text = generateShareText(calculation, currency);
    await Share.share(text, subject: 'Tip Calculator Result');
  }

  static String generateShareText(TipCalculation calculation, Currency currency) {
    final buffer = StringBuffer();
    buffer.writeln('💰 Tip Calculator Split');
    buffer.writeln('');
    buffer.writeln('Bill Amount: ${Formatters.formatCurrency(calculation.billAmount, currency)}');
    buffer.writeln('Tip: ${Formatters.formatPercentage(calculation.tipPercentage)} (${Formatters.formatCurrency(calculation.tipAmount, currency)})');
    buffer.writeln('Total: ${Formatters.formatCurrency(calculation.totalAmount, currency)}');
    buffer.writeln('');
    buffer.writeln('Split ${calculation.numberOfPeople} ways:');
    buffer.writeln('👤 Per Person: ${Formatters.formatCurrency(calculation.perPersonTotal, currency)}');
    buffer.writeln('');
    buffer.writeln('Shared via Tip Calculator App');
    return buffer.toString();
  }

  static String generateReceiptText(TipCalculation calculation, Currency currency) {
    final buffer = StringBuffer();
    buffer.writeln('═══════════════════════════');
    buffer.writeln('       TIP CALCULATOR');
    buffer.writeln('═══════════════════════════');
    buffer.writeln('');
    buffer.writeln('Bill Amount:');
    buffer.writeln('  ${Formatters.formatCurrency(calculation.billAmount, currency)}');
    buffer.writeln('');
    buffer.writeln('Tip (${Formatters.formatPercentage(calculation.tipPercentage)}):');
    buffer.writeln('  ${Formatters.formatCurrency(calculation.tipAmount, currency)}');
    buffer.writeln('───────────────────────────────────');
    buffer.writeln('Total:');
    buffer.writeln('  ${Formatters.formatCurrency(calculation.totalAmount, currency)}');
    buffer.writeln('');
    buffer.writeln('Split between ${calculation.numberOfPeople} people:');
    buffer.writeln('═══════════════════════════');
    buffer.writeln('PER PERSON: ${Formatters.formatCurrency(calculation.perPersonTotal, currency)}');
    buffer.writeln('═══════════════════════════');
    buffer.writeln('');
    buffer.writeln(Formatters.formatDateTime(calculation.timestamp));
    return buffer.toString();
  }

  static String generateSimpleText(TipCalculation calculation, Currency currency) {
    return 'Tip: ${Formatters.formatCurrency(calculation.perPersonTotal, currency)} per person';
  }
}
