import '../order/order_model.dart';
import '../reviews/review_model.dart';
import '../seller/seller_model.dart';

class CarApiModel {
  int? id;
  String? color;
  double? price;
  String? coverImage;
  String? createdAt;
  List<String>? images;
  int? sellerId;
  String? transmission;
  String? updatedAt;
  int? year;
  int? battery;
  String? brand;
  String? carType;
  double? speed;
  String? fuelType;
  bool? climate;
  String? country;
  double? range;
  int? seats;
  int? quantitySold;
  int? quantityInStock;
  Seller? seller;
  // List<Order>? orders;
  List<ReviewModel>? reviews;
  int? reviewCount;
  double? averageRating;
  int? totalBuyers;

  CarApiModel({
    this.id,
    this.color,
    this.price,
    this.coverImage,
    this.createdAt,
    this.images,
    this.sellerId,
    this.transmission,
    this.updatedAt,
    this.year,
    this.battery,
    this.brand,
    this.carType,
    this.speed,
    this.fuelType,
    this.climate,
    this.country,
    this.range,
    this.seats,
    this.quantitySold,
    this.quantityInStock,
    this.seller,
    // this.orders,
    this.reviews,
    this.reviewCount,
    this.averageRating,
    this.totalBuyers,
  });

  // تحويل JSON إلى كائن CarApiModel
  factory CarApiModel.fromJson(Map<String, dynamic> json) =>
      CarApiModel(
        id: json["id"],
        color: (json["color"]),
        price: json["price"]?.toDouble(),
        coverImage: json["coverImage"],
        createdAt: json["createdAt"],
        images: json["images"] != null ? List<String>.from(json["images"]) : [],
        sellerId: json["sellerId"],
        transmission: json["transmission"],
        updatedAt: json["updatedAt"],
        year: json["year"],
        battery: json["battery"],
        brand: json["brand"],
        carType: json["carType"],
        speed: json["speed"] != null
            ? double.tryParse(json["speed"].toString())
            : null,
        fuelType: json["fuelType"],
        climate: json["climate"],
        country: json["country"],
        range: json["range"] != null
            ? double.tryParse(json["range"].toString())
            : null,
        seats: json["seats"],
        quantitySold: json["quantitySold"] ?? 0,
        quantityInStock: json["quantityInStock"] ?? 0,
        seller: json["seller"] != null ? Seller.fromJson(json["seller"]) : null,
        // orders: json["orders"] != null ? List<Order>.from(
        //     json["orders"].map((x) => Order.fromJson(x))) : [],
        reviews: json["reviews"] != null ? List<ReviewModel>.from(
            json["reviews"].map((x) => ReviewModel.fromJson(x))) : [],
        reviewCount: json["reviewCount"],
        averageRating: json["averageRating"]?.toDouble(),
        totalBuyers: json["totalBuyers"],
      );

// تحويل الكائن إلى JSON
// Map<String, dynamic> toJson() => {
//   "id": id,
//   "color": color,
//   "price": price,
//   "coverImage": coverImage,
//   "createdAt": createdAt,
//   "images": images ?? [],
//   "sellerId": sellerId,
//   "transmission": transmission,
//   "updatedAt": updatedAt,
//   "year": year,
//   "battery": battery,
//   "brand": brand,
//   "carType": carType,
//   "speed": speed,
//   "fuelType": fuelType,
//   "climate": climate,
//   "country": country,
//   "range": range,
//   "seats": seats,
//   "quantitySold": quantitySold,
//   "quantityInStock": quantityInStock,
//   "seller": seller?.toJson(),
//   "orders": orders?.map((x) => x.toJson()).toList() ?? [],
//   "reviews": reviews?.map((x) => x.toJson()).toList() ?? [],
//   "reviewCount": reviewCount,
//   "averageRating": averageRating,
//   "totalBuyers": totalBuyers,
// };
//   static String _extractColor(dynamic colorData) {
//     if (colorData == null) return "Unknown";
//
//     // استخراج اللون من النص
//     RegExp regex = RegExp(r'Color\((0x[0-9a-fA-F]+)\)');
//     Match? match = regex.firstMatch(colorData.toString());
//
//     if (match != null) {
//       return match.group(1) ?? "Unknown";
//     }
//
//     return "Unknown";
//   }
// }
// عرض تفاصيل الكائن عند الطباعة
// @override
// String toString() {
//   return 'CarApiModel(id: $id, color: $color, price: $price, brand: $brand, year: $year)';
// }

}