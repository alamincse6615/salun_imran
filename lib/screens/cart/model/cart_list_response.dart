import '../../product/model/product_list_response.dart';
import '../../product/model/product_review_data_model.dart';

class CartListResponse {
  List<CartListData>? data;
  CartPriceData? cartPriceData;
  String? message;
  bool? status;

  CartListResponse({this.data, this.message, this.status, this.cartPriceData});

  factory CartListResponse.fromJson(Map<String, dynamic> json) {
    return CartListResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => CartListData.fromJson(i)).toList() : null,
      cartPriceData: json['price'] != null ? CartPriceData.fromJson(json['price']) : null,
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
    if (this.cartPriceData != null) {
      data['price'] = this.cartPriceData!.toJson();
    }
    return data;
  }
}

class CartListData {
  String? createdAt;
  String? deletedAt;
  int? id;
  String? productDescription;
  String? productVariationType;
  String? productVariationName;
  String? productVariationValue;
  int? productId;
  String? productImage;
  String? productName;
  VariationData? productVariation;
  int? productVariationId;
  int? qty;
  String? unitName;
  String? updatedAt;
  int? userId;
  num? discountValue;
  String? discountType;

  ///order list
  num? taxIncludeProductPrice;
  num? getProductPrice;
  num? productAmount;
  ProductReviewDataModel? productReviewData;

  //local
  bool get isDiscount => discountValue != null && discountValue != 0;

  CartListData({
    this.createdAt,
    this.deletedAt,
    this.id,
    this.productDescription,
    this.productVariationName,
    this.productVariationType,
    this.productVariationValue,
    this.productId,
    this.productImage,
    this.productName,
    this.productVariation,
    this.productVariationId,
    this.qty,
    this.unitName,
    this.updatedAt,
    this.userId,
    this.discountValue,
    this.discountType,
    this.taxIncludeProductPrice,
    this.getProductPrice,
    this.productAmount,
    this.productReviewData,
  });

  factory CartListData.fromJson(Map<String, dynamic> json) {
    return CartListData(
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'] != null ? json['deleted_at'] : null,
      id: int.tryParse(json['id'].toString()),
      productDescription: json['product_description'],
      productVariationType: json['product_variation_type'],
      productVariationName: json['product_variation_name'],
      productVariationValue: json['product_variation_value'],
      productId: int.tryParse(json['product_id'].toString()),
      productImage: json['product_image'],
      productName: json['product_name'],
      productVariation: json['product_variation'] != null ? VariationData.fromJson(json['product_variation']) : null,
      productVariationId: json['product_variation_id'],
      qty: int.tryParse(json['qty'].toString()),
      unitName: json['unit_name'],
      updatedAt: json['updated_at'],
      userId: int.tryParse(json['user_id'].toString()),
      discountValue: num.tryParse(json['discount_value'].toString()),
      discountType: json['discount_type'],
      taxIncludeProductPrice: num.tryParse(json['tax_include_product_price'].toString()),
      getProductPrice: num.tryParse(json['get_product_price'].toString()),
      productAmount: num.tryParse(json['product_amount'].toString()),
      productReviewData: json['product_review'] != null ? ProductReviewDataModel.fromJson(json['product_review']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['product_description'] = this.productDescription;
    data['product_variation_type'] = this.productVariationType;
    data['product_variation_name'] = this.productVariationName;
    data['product_variation_value'] = this.productVariationValue;
    data['product_id'] = this.productId;
    data['product_image'] = this.productImage;
    data['product_name'] = this.productName;
    data['product_variation_id'] = this.productVariationId;
    data['qty'] = this.qty;
    data['unit_name'] = this.unitName;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['user_id'] = this.userId;
    data['discount_value'] = this.discountValue;
    data['discount_type'] = this.discountType;
    data['tax_include_product_price'] = this.taxIncludeProductPrice;
    data['get_product_price'] = this.getProductPrice;
    data['product_amount'] = this.productAmount;
    if (this.productVariation != null) {
      data['product_variation'] = this.productVariation!.toJson();
    }
    if (this.productReviewData != null) {
      data['product_review'] = this.productReviewData!.toJson();
    }
    return data;
  }
}

class CartPriceData {
  num? discountAmount;
  num? taxAmount;
  num? taxIncludedAmount;
  num? totalAmount;
  num? totalPayableAmount;
  CartTaxData? taxData;

  CartPriceData({
    this.discountAmount,
    this.taxAmount,
    this.taxIncludedAmount,
    this.totalAmount,
    this.totalPayableAmount,
    this.taxData,
  });

  factory CartPriceData.fromJson(Map<String, dynamic> json) {
    return CartPriceData(
      discountAmount: int.tryParse(json['discount_amount'].toString()),
      taxAmount: num.tryParse(json['tax_amount'].toString()),
      taxIncludedAmount: num.tryParse(json['tax_included_amount'].toString()),
      totalAmount: num.tryParse(json['total_amount'].toString()),
      totalPayableAmount: json['total_payable_amount'],
      taxData: json['tax_data'] != null ? CartTaxData.fromJson(json['tax_data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discount_amount'] = this.discountAmount;
    data['tax_included_amount'] = this.taxIncludedAmount;
    data['total_amount'] = this.totalAmount;
    data['tax_amount'] = this.taxAmount;
    data['total_payable_amount'] = this.totalPayableAmount;
    if (this.taxData != null) {
      data['tax_data'] = this.taxData!.toJson();
    }
    return data;
  }
}

class CartTaxData {
  List<TaxDetail>? taxDetails;
  num? totalTaxAmount;

  CartTaxData({this.taxDetails, this.totalTaxAmount});

  factory CartTaxData.fromJson(Map<String, dynamic> json) {
    return CartTaxData(
      taxDetails: json['tax_details'] != null ? (json['tax_details'] as List).map((i) => TaxDetail.fromJson(i)).toList() : null,
      totalTaxAmount: json['total_tax_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_tax_amount'] = this.totalTaxAmount;
    if (this.taxDetails != null) {
      data['tax_details'] = this.taxDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaxDetail {
  num? taxAmount;
  String? taxName;
  String? taxType;
  num? taxValue;

  TaxDetail({this.taxAmount, this.taxName, this.taxType, this.taxValue});

  factory TaxDetail.fromJson(Map<String, dynamic> json) {
    return TaxDetail(
      taxAmount: num.tryParse(json['tax_amount'].toString())??0,
      taxName: json['tax_name'],
      taxType: json['tax_type'],
      taxValue: num.tryParse(json['tax_value'].toString())??0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tax_amount'] = this.taxAmount;
    data['tax_name'] = this.taxName;
    data['tax_type'] = this.taxType;
    data['tax_value'] = this.taxValue;
    return data;
  }
}
