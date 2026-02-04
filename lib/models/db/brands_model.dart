import 'dart:convert';

class BrandModel {
  late String brandName;
  late bool isSelected;
  BrandModel({required this.brandName,this.isSelected=false});
  Map<String,dynamic> toJson(){
    Map<String,dynamic> json={};
    json['brandName']=brandName;

    // json['isSelected']=false ;
    return json;
  }

  BrandModel.fromJson(Map<String,dynamic> json){
     brandName=json['brandName'];
     // isSelected=json['isSelected'];

  }


}