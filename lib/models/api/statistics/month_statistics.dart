
import '../cars/car_api_model.dart';


class MonthStatistics{
String month;
List<CarApiModel> cars;

MonthStatistics({
  required this.month,
  required this.cars,
});

factory MonthStatistics.fromJson(Map<String, dynamic> json) => MonthStatistics(
month: json["month"],
cars: List<CarApiModel>.from(json["cars"].map((x) => CarApiModel.fromJson(x))),
);

// Map<String, dynamic> toJson() => {
// "month": month,
// "cars": List<dynamic>.from(cars.map((x) => x.toJson())),
// };


}