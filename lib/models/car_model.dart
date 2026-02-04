import 'dart:ui';

import 'package:carmarketapp/models/api/reviews/review_model.dart';

import 'api/order/order_model.dart';

class CarModel{
 late String carBrand;
 late String carType;
 late Color color;
 late int? quantity;
 late int speed;
 late double battery;
 late double range;
 late double price;
 late String climate;
 late String transmissionType;
 late List<String> carImages;
 late String carCoverImage;
 late int seats;
 List<Order>? orders;
 List<ReviewModel>? reviews;
 int? reviewCount;
 int? averageRating;

 CarModel(
      {
  required      this.carBrand,
  required    this.carType,
  required    this.color,
  required    this.quantity,
  required    this.speed,
        required     this.battery,
  required    this.range,
   required   this.price,
   required   this.climate,
   required   this.transmissionType,
   required   this.carImages,
    required  this.carCoverImage,
    required  this.seats,



      });
 CarModel.fromJson(Map<String,dynamic> json){
   Map<String,dynamic> json={};
   carBrand=json['carBrand'];
   carType=json['carType'];
   color=json['color'];
   quantity=json["quantity"];
   speed=json['speed'];
    battery=json['battery'];

 range=json['range'];

   price=json['price'];
   climate=json['climate'];
    transmissionType=json['transmissionType'];


  carImages=json['carImages'];

   carCoverImage=json['carCoverImage'];
   seats=json['seats'];

 }
 Map<String,dynamic> toJson(){
   Map<String,dynamic> json={};

   json['carBrand']= carBrand;
   json['carType']=carType;
   json['color']=color;

   json["quantity"]=quantity;
   json['speed']=speed;
   json['battery']=battery;
   json['range']=range;
   json['price']=price;
   json['climate']=climate;
   json['transmissionType']=transmissionType;



   json['carImages']=carImages;

 json['carCoverImage']=carCoverImage;
   json['seats']=seats;
   return json;
 }

}