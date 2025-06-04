import 'package:frezka/main.dart';

class ServiceResponse {
  List<ServiceListData>? data;
  String? message;
  bool? status;

  ServiceResponse({this.data, this.message, this.status});

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => ServiceListData.fromJson(i)).toList() : null,
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

class ServiceListData {
  int? categoryId;
  String? createdAt;
  int? createdBy;
  int? defaultPrice;
  String? deletedAt;
  int? deletedBy;
  String? description;
  int? durationMin;
  int? id;
  String? name;
  String? serviceImage;
  String? slug;
  int? status;
  int? subCategoryId;
  String? updatedAt;
  int? updatedBy;
  String? startDateTime;
  DateTime? previousTime;

  bool isServiceChecked;

  // for booking wise service
  int? servicePrice;
  int? serviceId;
  String? serviceName;

  ServiceListData({
    this.categoryId,
    this.createdAt,
    this.createdBy,
    this.defaultPrice,
    this.servicePrice,
    this.deletedAt,
    this.deletedBy,
    this.description,
    this.durationMin,
    this.id,
    this.name,
    this.serviceId,
    this.serviceName,
    this.serviceImage,
    this.slug,
    this.status,
    this.subCategoryId,
    this.updatedAt,
    this.updatedBy,
    this.isServiceChecked = false,
    this.startDateTime,
  });

  factory ServiceListData.fromJson(Map<String, dynamic> json) {
    return ServiceListData(
      categoryId: int.tryParse(json['category_id'].toString()),
      createdAt: json['created_at'],
      createdBy: json['created_by'] != null ? int.tryParse(json['created_by'].toString()) : null,
      defaultPrice: int.tryParse(json['default_price'].toString())??0,
      servicePrice: int.tryParse(json['service_price'].toString()),
      deletedAt: json['deleted_at'] != null ? json['deleted_at'] : null,
      deletedBy: json['deleted_by'] != null ? int.tryParse(json['deleted_by'].toString()) : null,
      description: json['description'],
      durationMin: int.tryParse(json['duration_min'].toString()),
      id: int.tryParse(json['id'].toString()),
      name: json['name'],
      serviceId: int.tryParse(json['service_id'].toString())??0,
      serviceName: json['service_name'],
      serviceImage: json['service_image'] != null ? json['service_image'] : null,
      slug: json['slug'],
      status: int.tryParse(json['status'].toString()),
      subCategoryId: json['sub_category_id'] != null ? int.tryParse(json['sub_category_id'].toString()) : null,
      updatedAt: json['updated_at'],
      updatedBy: json['updated_by'] != null ? int.tryParse(json['updated_by'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['default_price'] = this.defaultPrice;
    data['service_price'] = this.servicePrice;
    data['description'] = this.description;
    data['duration_min'] = this.durationMin;
    data['id'] = this.id;
    data['name'] = this.name;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy;
    }
    if (this.deletedAt != null) {
      data['deleted_at'] = this.deletedAt;
    }
    if (this.deletedBy != null) {
      data['deleted_by'] = this.deletedBy;
    }
    if (this.serviceImage != null) {
      data['service_image'] = this.serviceImage;
    }
    if (this.subCategoryId != null) {
      data['sub_category_id'] = this.subCategoryId;
    }
    if (this.updatedBy != null) {
      data['updated_by'] = this.updatedBy;
    }
    data['start_date_time'] = this.startDateTime;

    return data;
  }

  /// For Save Booking
  Map<String, dynamic> toBookingServiceJson({bool isUpdate = false, bool isRescheduleBooking = false}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = (isUpdate || isRescheduleBooking) ? this.serviceId : this.id;
    data['service_price'] = (isUpdate || isRescheduleBooking) ? this.servicePrice : this.defaultPrice;
    if (bookingRequestStore.employeeId != -1) data['employee_id'] = bookingRequestStore.employeeId;
    data['duration_min'] = this.durationMin;
    data['start_date_time'] = this.startDateTime;
    return data;
  }
}
