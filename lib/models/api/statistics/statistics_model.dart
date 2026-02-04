
import 'dart:convert';
import 'month_statistics.dart';

List<StatisticsBaseModel> statisticsBaseModelFromJson(String str) => List<StatisticsBaseModel>.from(json.decode(str).map((x) => StatisticsBaseModel.fromJson(x)));


class StatisticsBaseModel {
  final List<MonthStatistics> data;

  StatisticsBaseModel({required this.data});

  factory StatisticsBaseModel.fromJson(List<dynamic> json) {
    return StatisticsBaseModel(
      data: json.map((e) => MonthStatistics.fromJson(e)).toList(),
    );
  }
}
