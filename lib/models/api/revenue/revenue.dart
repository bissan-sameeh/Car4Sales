// To parse this JSON data, do
//
//     final revenuee = revenueeFromJson(jsonString);

import 'dart:convert';

RevenueModel revenueeFromJson(String str) => RevenueModel.fromJson(json.decode(str));

String revenueeToJson(RevenueModel data) => json.encode(data.toJson());

class RevenueModel {
  YearlyRevenue? yearlyRevenue;
  Map<String, double>? monthlyRevenue;
  double? totalRevenue;

  RevenueModel({
    this.yearlyRevenue,
    this.monthlyRevenue,
    this.totalRevenue,
  });

  factory RevenueModel.fromJson(Map<String, dynamic> json) => RevenueModel(
    yearlyRevenue: json["yearlyRevenue"] == null ? null : YearlyRevenue.fromJson(json["yearlyRevenue"]),
    monthlyRevenue: Map.from(json["monthlyRevenue"]!).map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
    totalRevenue: json["totalRevenue"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "yearlyRevenue": yearlyRevenue?.toJson(),
    "monthlyRevenue": Map.from(monthlyRevenue!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "totalRevenue": totalRevenue,
  };
}

class YearlyRevenue {
  double? the2025;

  YearlyRevenue({
    this.the2025,
  });

  factory YearlyRevenue.fromJson(Map<String, dynamic> json) => YearlyRevenue(
    the2025: json["2025"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "2025": the2025,
  };
}
