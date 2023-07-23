import 'dart:convert';

Currency currencyFromJson(String str) => Currency.fromJson(json.decode(str));

String currencyToJson(Currency data) => json.encode(data.toJson());

class Currency {
  Currency({
    this.amount,
    this.base,
    this.date,
    this.rates,
  });

  final double? amount;
  final String? base;
  final DateTime? date;
  final Map<String, double>? rates;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    amount: json["amount"],
    base: json["base"],
    date: DateTime.parse(json["date"]),
    rates: Map.from(json["rates"])
        .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "base": base,
    "date": date != null
    ? "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}"
    :null,
    "rates": Map.from(rates ??{}).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}