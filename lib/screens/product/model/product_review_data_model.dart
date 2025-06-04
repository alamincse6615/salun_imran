class ProductReviewsResponse {
  List<ProductReviewDataModel>? data;
  String? message;
  bool? status;

  ProductReviewsResponse({this.data, this.message, this.status});

  factory ProductReviewsResponse.fromJson(Map<String, dynamic> json) {
    return ProductReviewsResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => ProductReviewDataModel.fromJson(i)).toList() : null,
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductReviewDataModel {
  int? id;
  int? productId;
  int? rating;
  int? reviewDislikes;
  int? isUserLike;
  int? isUserDislike;
  List<ReviewGallaryData>? reviewGallary;
  int? reviewLikes;
  String? reviewMsg;
  int? userId;
  String? userName;
  String? createdAt;
  String? deletedAt;
  String? updatedAt;

  ///order detail
  String? featureImage;
  List<ReviewGallaryData>? gallery;
  int? productVariationId;

  ProductReviewDataModel({
    this.id,
    this.productId,
    this.rating,
    this.reviewDislikes,
    this.isUserLike,
    this.isUserDislike,
    this.reviewGallary,
    this.reviewLikes,
    this.reviewMsg,
    this.userId,
    this.userName,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.featureImage,
    this.gallery,
    this.productVariationId,
  });

  factory ProductReviewDataModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewDataModel(
      id: int.tryParse(json['id'].toString()),
      productId: int.tryParse(json['product_id'].toString()),
      rating: int.tryParse(json['rating'].toString()),
      reviewDislikes: int.tryParse(json['review_dislikes'].toString()),
      isUserLike: int.tryParse(json['is_user_like'].toString()),
      isUserDislike: int.tryParse(json['is_user_dislike'].toString()),
      reviewGallary: json['review_gallary'] != null ? (json['review_gallary'] as List).map((i) => ReviewGallaryData.fromJson(i)).toList() : null,
      reviewLikes: int.tryParse(json['review_likes'].toString()),
      reviewMsg: json['review_msg'],
      userId: int.tryParse(json['user_id'].toString()),
      userName: json['user_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'] != null ? json['deleted_at'] : null,
      featureImage: json['feature_image'],
      gallery: json['gallery'] != null ? (json['gallery'] as List).map((i) => ReviewGallaryData.fromJson(i)).toList() : null,
      productVariationId: int.tryParse(json['product_variation_id'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['rating'] = this.rating;
    data['review_dislikes'] = this.reviewDislikes;
    data['is_user_like'] = this.isUserLike;
    data['is_user_dislike'] = this.isUserDislike;
    data['review_likes'] = this.reviewLikes;
    data['review_msg'] = this.reviewMsg;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.reviewGallary != null) {
      data['review_gallary'] = this.reviewGallary!.map((v) => v.toJson()).toList();
    }
    if (this.deletedAt != null) {
      data['deleted_at'] = this.deletedAt;
    }
    return data;
  }
}

class ReviewGallaryData {
  String? createdAt;
  int? createdBy;
  String? deletedAt;
  int? deletedBy;
  String? fullUrl;
  int? id;
  int? reviewId;
  int? status;
  String? updatedAt;
  int? updatedBy;

  ReviewGallaryData({this.createdAt, this.createdBy, this.deletedAt, this.deletedBy, this.fullUrl, this.id, this.reviewId, this.status, this.updatedAt, this.updatedBy});

  factory ReviewGallaryData.fromJson(Map<String, dynamic> json) {
    return ReviewGallaryData(
      createdAt: json['created_at'],
      createdBy: int.tryParse(json['created_by'].toString()),
      deletedAt: json['deleted_at'] != null ? json['deleted_at'] : null,
      deletedBy: json['deleted_by'] != null ? int.tryParse(json['deleted_by'].toString()) : null,
      fullUrl: json['full_url'],
      id: int.tryParse(json['id'].toString()),
      reviewId: int.tryParse(json['review_id'].toString()),
      status: int.tryParse(json['status'].toString()),
      updatedAt: json['updated_at'],
      updatedBy: int.tryParse(json['updated_by'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['full_url'] = this.fullUrl;
    data['id'] = this.id;
    data['review_id'] = this.reviewId;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    if (this.deletedAt != null) {
      data['deleted_at'] = this.deletedAt;
    }
    if (this.deletedBy != null) {
      data['deleted_by'] = this.deletedBy;
    }
    return data;
  }
}

class ProductReviewLikeDislikeModel {
  int? dislikeCount;
  int? likeCount;
  String? message;
  bool? status;

  ProductReviewLikeDislikeModel({this.dislikeCount, this.likeCount, this.message, this.status});

  factory ProductReviewLikeDislikeModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewLikeDislikeModel(
      dislikeCount: json['dislike_count'],
      likeCount: json['like_count'],
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dislike_count'] = this.dislikeCount;
    data['like_count'] = this.likeCount;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}