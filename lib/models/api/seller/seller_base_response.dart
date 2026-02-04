import 'dart:convert';

import 'package:carmarketapp/models/api/seller/seller_model.dart';

SellerBaseResponse sellerBaseResponseFromJson(String str) => SellerBaseResponse.fromJson(json.decode(str));

String sellerBaseResponseToJson(SellerBaseResponse data) => json.encode(data.toJson());

class SellerBaseResponse {
  int? length;
  Seller? seller;

  SellerBaseResponse({
    this.length,
    this.seller,
  });

  factory SellerBaseResponse.fromJson(Map<String, dynamic> json) => SellerBaseResponse(
    length: json["length"],
    seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
  );

  Map<String, dynamic> toJson() => {
    "length": length,
    "seller": seller?.toJson(),
  };
}