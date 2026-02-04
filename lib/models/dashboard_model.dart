import 'package:flutter/cupertino.dart';

class DashboardModel{
   late dynamic icon;
   late String? title;
   late Color? color;

  DashboardModel({ this.icon,  this.title, this.color});
  Map<String, dynamic> toJson(){
    Map<String,dynamic> json={};
    json['icon']=icon;
    json['title']=title;
    json['color']=color;
    return json;
  }
 DashboardModel.fromJson(Map<String,dynamic> json){
    Map<String,dynamic> json={};
    icon=json['icon'];
    title=json['title'];
    color=json['color'];

  }
}