import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/common_base.dart';

class ReviewData {
  int? id;
  int? staffId;
  int? userId;
  String? reviewMsg;
  num? rating;
  String? username;
  String? createdAt;

  Color? get ratingColor => getRatingBarColor(rating.validate().toInt());

  ReviewData({this.id, this.staffId, this.userId, this.reviewMsg, this.rating, this.username, this.createdAt});

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      id: int.tryParse(json['id'].toString())??-1,
      staffId: int.tryParse(json['employee_id'].toString())??-1,
      userId: int.tryParse(json['user_id'])??-1,
      reviewMsg: json['review_msg'],
      rating: num.tryParse(json['rating'].toString())??0,
      username: json['username'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.staffId;
    data['user_id'] = this.userId;
    data['review_msg'] = this.reviewMsg;
    data['rating'] = this.rating;
    data['username'] = this.username;
    data['created_at'] = this.createdAt;
    return data;
  }
}
