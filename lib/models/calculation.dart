import 'package:uuid/uuid.dart';

enum RoundingOption {
  none,
  roundUp,
  roundDown,
  roundToNearest,
}

extension RoundingOptionExtension on RoundingOption {
  String get displayName {
    switch (this) {
      case RoundingOption.none:
        return 'None';
      case RoundingOption.roundUp:
        return 'Round Up';
      case RoundingOption.roundDown:
        return 'Round Down';
      case RoundingOption.roundToNearest:
        return 'Nearest \$1';
    }
  }

  String get tooltip {
    switch (this) {
      case RoundingOption.none:
        return 'No rounding applied';
      case RoundingOption.roundUp:
        return 'Round per person amount up';
      case RoundingOption.roundDown:
        return 'Round per person amount down';
      case RoundingOption.roundToNearest:
        return 'Round to nearest dollar';
    }
  }
}

class TipCalculation {
  final String id;
  final double billAmount;
  final double tipPercentage;
  final int numberOfPeople;
  final double tipAmount;
  final double totalAmount;
  final double perPersonTotal;
  final double perPersonTip;
  final DateTime timestamp;
  final RoundingOption rounding;

  TipCalculation({
    required this.id,
    required this.billAmount,
    required this.tipPercentage,
    required this.numberOfPeople,
    required this.tipAmount,
    required this.totalAmount,
    required this.perPersonTotal,
    required this.perPersonTip,
    required this.timestamp,
    required this.rounding,
  });

  factory TipCalculation.calculate({
    required double billAmount,
    required double tipPercentage,
    required int numberOfPeople,
    required RoundingOption rounding,
  }) {
    final tipAmt = billAmount * (tipPercentage / 100);
    final totalAmt = billAmount + tipAmt;
    double perPerson = totalAmt / numberOfPeople;
    final perPersonTip = tipAmt / numberOfPeople;

    // Apply rounding
    switch (rounding) {
      case RoundingOption.roundUp:
        perPerson = perPerson.ceilToDouble();
        break;
      case RoundingOption.roundDown:
        perPerson = perPerson.floorToDouble();
        break;
      case RoundingOption.roundToNearest:
        perPerson = perPerson.roundToDouble();
        break;
      case RoundingOption.none:
        // No rounding
        break;
    }

    return TipCalculation(
      id: const Uuid().v4(),
      billAmount: billAmount,
      tipPercentage: tipPercentage,
      numberOfPeople: numberOfPeople,
      tipAmount: tipAmt,
      totalAmount: totalAmt,
      perPersonTotal: perPerson,
      perPersonTip: perPersonTip,
      timestamp: DateTime.now(),
      rounding: rounding,
    );
  }

  TipCalculation copyWith({
    String? id,
    double? billAmount,
    double? tipPercentage,
    int? numberOfPeople,
    double? tipAmount,
    double? totalAmount,
    double? perPersonTotal,
    double? perPersonTip,
    DateTime? timestamp,
    RoundingOption? rounding,
  }) {
    return TipCalculation(
      id: id ?? this.id,
      billAmount: billAmount ?? this.billAmount,
      tipPercentage: tipPercentage ?? this.tipPercentage,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      tipAmount: tipAmount ?? this.tipAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      perPersonTotal: perPersonTotal ?? this.perPersonTotal,
      perPersonTip: perPersonTip ?? this.perPersonTip,
      timestamp: timestamp ?? this.timestamp,
      rounding: rounding ?? this.rounding,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'billAmount': billAmount,
      'tipPercentage': tipPercentage,
      'numberOfPeople': numberOfPeople,
      'tipAmount': tipAmount,
      'totalAmount': totalAmount,
      'perPersonTotal': perPersonTotal,
      'perPersonTip': perPersonTip,
      'timestamp': timestamp.toIso8601String(),
      'rounding': rounding.index,
    };
  }

  factory TipCalculation.fromJson(Map<String, dynamic> json) {
    return TipCalculation(
      id: json['id'] as String,
      billAmount: (json['billAmount'] as num).toDouble(),
      tipPercentage: (json['tipPercentage'] as num).toDouble(),
      numberOfPeople: json['numberOfPeople'] as int,
      tipAmount: (json['tipAmount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      perPersonTotal: (json['perPersonTotal'] as num).toDouble(),
      perPersonTip: (json['perPersonTip'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      rounding: RoundingOption.values[json['rounding'] as int],
    );
  }
}
