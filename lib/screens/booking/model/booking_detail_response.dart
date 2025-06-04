import 'package:frezka/screens/booking/model/booking_list_response.dart';

class BookingDetailResponse {
  BookingListData? data;
  String? message;
  bool? status;

  BookingDetailResponse({this.data, this.message, this.status});

  factory BookingDetailResponse.fromJson(Map<String, dynamic> json) {
    return BookingDetailResponse(
      data: json['data'] != null ? BookingListData.fromJson(json['data']) : null,
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Payment {
  int? bookingId;
  String? createdAt;
  int? createdBy;
  String? createdGuard;
  String? deletedAt;
  int? deletedBy;
  String? deletedGuard;
  num? discountAmount;
  num? discountPercentage;
  String? externalTransactionId;
  int? id;
  int? paymentStatus;
  String? requestToken;
  List<TaxPercentage>? taxPercentage;
  int? tipAmount;
  String? transactionType;
  String? updatedAt;
  int? updatedBy;
  String? updatedGuard;

  Payment({
    this.bookingId,
    this.createdAt,
    this.createdBy,
    this.createdGuard,
    this.deletedAt,
    this.deletedBy,
    this.deletedGuard,
    this.discountAmount,
    this.discountPercentage,
    this.externalTransactionId,
    this.id,
    this.paymentStatus,
    this.requestToken,
    this.taxPercentage,
    this.tipAmount,
    this.transactionType,
    this.updatedAt,
    this.updatedBy,
    this.updatedGuard,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      bookingId: int.tryParse(json['booking_id'].toString())??0,
      createdAt: json['created_at'],
      createdBy: json['created_by'] != null ? int.tryParse(json['created_by'].toString()) : null,
      createdGuard: json['created_guard'],
      deletedAt: json['deleted_at'] != null ? json['deleted_at'] : null,
      deletedBy: json['deleted_by'] != null ? int.tryParse(json['deleted_by'].toString()) : null,
      deletedGuard: json['deleted_guard'],
      discountAmount: num.tryParse(json['discount_amount'].toString())??0,
      discountPercentage: num.tryParse(json['discount_percentage'].toString())??0,
      externalTransactionId: json['external_transaction_id'],
      id: int.tryParse(json['id'].toString())??0,
      paymentStatus: int.tryParse(json['payment_status']),
      requestToken: json['request_token'] != null ? json['request_token'] : null,
      taxPercentage: json['tax_percentage'] != null ? (json['tax_percentage'] as List).map((i) => TaxPercentage.fromJson(i)).toList() : null,
      tipAmount: int.tryParse(json['tip_amount'].toString()),
      transactionType: json['transaction_type'],
      updatedAt: json['updated_at'],
      updatedBy: json['updated_by'] != null ? int.tryParse(json['updated_by'].toString()) : null,
      updatedGuard: json['updated_guard'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['created_at'] = this.createdAt;
    data['created_guard'] = this.createdGuard;
    data['deleted_guard'] = this.deletedGuard;
    data['discount_amount'] = this.discountAmount;
    data['discount_percentage'] = this.discountPercentage;
    data['external_transaction_id'] = this.externalTransactionId;
    data['id'] = this.id;
    data['payment_status'] = this.paymentStatus;
    data['tip_amount'] = this.tipAmount;
    data['transaction_type'] = this.transactionType;
    data['updated_at'] = this.updatedAt;
    data['updated_guard'] = this.updatedGuard;
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy;
    }
    if (this.deletedAt != null) {
      data['deleted_at'] = this.deletedAt;
    }
    if (this.deletedBy != null) {
      data['deleted_by'] = this.deletedBy;
    }
    if (this.requestToken != null) {
      data['request_token'] = this.requestToken;
    }
    if (this.taxPercentage != null) {
      data['tax_percentage'] = this.taxPercentage!.map((v) => v.toJson()).toList();
    }
    if (this.updatedBy != null) {
      data['updated_by'] = this.updatedBy;
    }
    return data;
  }
}

class TaxPercentage {
  String? name;
  int? id;
  num? percent;
  num? taxAmount;
  String? type;

  TaxPercentage({this.id, this.name, this.percent, this.taxAmount, this.type});

  factory TaxPercentage.fromJson(Map<String, dynamic> json) {
    return TaxPercentage(
      id: int.tryParse(json['id'].toString()),
      name: json['name'],
      percent: num.tryParse(json['percent'].toString()),
      taxAmount: num.tryParse(json['tax_amount'].toString()),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['percent'] = this.percent;
    data['tax_amount'] = this.taxAmount;
    data['type'] = this.type;
    return data;
  }
}

class ProductsInfo {
  int? bookingId;
  String? discountType;
  num? discountValue;
  num? discountedPrice;
  int? employeeId;
  int? id;
  int? orderId;
  int? productId;
  String? productName;
  num? productPrice;
  int? productQty;
  int? productVariationId;
  String? variationName;
  String? productImage;

  ProductsInfo({
    this.bookingId,
    this.discountType,
    this.discountValue,
    this.discountedPrice,
    this.employeeId,
    this.id,
    this.orderId,
    this.productId,
    this.productName,
    this.productPrice,
    this.productQty,
    this.productVariationId,
    this.variationName,
    this.productImage,
  });

  factory ProductsInfo.fromJson(Map<String, dynamic> json) {
    return ProductsInfo(
      bookingId: int.tryParse(json['booking_id'].toString())??0,
      discountType: json['discount_type'],
      discountValue: num.tryParse(json['discount_value'].toString())??0,
      discountedPrice: num.tryParse(json['discounted_price'].toString())??0,
      employeeId: int.tryParse(json['employee_id'].toString())??0,
      id: int.tryParse(json['id'].toString())??0,
      orderId: int.tryParse(json['order_id'].toString())??0,
      productId: int.tryParse(json['product_id'].toString())??0,
      productName: json['product_name'],
      productPrice: num.tryParse(json['product_price'].toString())??0,
      productQty: int.tryParse(json['product_qty'].toString())??0,
      productVariationId: int.tryParse(json['product_variation_id'].toString())??0,
      variationName: json['variation_name'],
      productImage: json['product_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['discount_type'] = this.discountType;
    data['discount_value'] = this.discountValue;
    data['discounted_price'] = this.discountedPrice;
    data['employee_id'] = this.employeeId;
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_price'] = this.productPrice;
    data['product_qty'] = this.productQty;
    data['product_variation_id'] = this.productVariationId;
    data['variation_name'] = this.variationName;
    data['product_image'] = this.productImage;
    return data;
  }
}
