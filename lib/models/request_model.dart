import 'package:fyndr/models/merchant_model.dart';

class RequestModel {
  final String? id;
  final String? user;
  final List<String>? possibleMerchants;
  final List<InterestedMerchant>? interestedMerchants;
  final String? acceptedMerchant;
  final String? requestStatus;
  final String? title;
  final String? category;
  final String? targetState;
  final List<String>? targetAxis;
  final String? additionalDetails;
  final String? requirements;
  final CarHire? carHire;
  final Cleaning? cleaning;
  final RealEstate? realEstate;
  final CarPart? carPart;
  final Automobile? automobile;

  final String? transactionId;
  final String? transactionReference;
  final String? paymentMethod;
  final String? transactionStatus;
  final String? paymentAttempt;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  RequestModel({
    this.id,
    this.user,
    this.possibleMerchants,
    this.acceptedMerchant,
    this.interestedMerchants,
    this.requestStatus,
    this.title,
    this.category,
    this.targetState,
    this.targetAxis,
    this.additionalDetails,
    this.requirements,
    this.carHire,
    this.cleaning,
    this.realEstate,
    this.carPart,
    this.automobile,
    this.transactionStatus,
    this.createdAt,
    this.updatedAt,
    this.transactionId,
    this.transactionReference,
    this.paymentMethod,
    this.paymentAttempt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['_id'],
      user: json['user'],
      possibleMerchants:
          (json['possibleMerchants'] as List?)
              ?.map((e) => e.toString())
              .toList(),


      interestedMerchants: json['interestedMerchants'] != null
          ? List<InterestedMerchant>.from(
          json['interestedMerchants'].map((x) => InterestedMerchant.fromJson(x)))
          : [],


      acceptedMerchant: json['acceptedMerchant'],
      requestStatus: json['requestStatus'],
      title: json['title'],
      category: json['category'],
      targetState: json['targetState'],
      targetAxis:
          (json['targetAxis'] as List?)?.map((e) => e.toString()).toList(),
      additionalDetails: json['additionalDetails'],
      requirements: json['requirements'],
      carHire:
          json['carHire'] != null ? CarHire.fromJson(json['carHire']) : null,
      cleaning:
          json['cleaning'] != null ? Cleaning.fromJson(json['cleaning']) : null,
      realEstate:
          json['realEstate'] != null
              ? RealEstate.fromJson(json['realEstate'])
              : null,
      carPart:
          json['carPart'] != null ? CarPart.fromJson(json['carPart']) : null,
      automobile:
          json['automobile'] != null
              ? Automobile.fromJson(json['automobile'])
              : null,
      transactionStatus: json['transaction_status'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      transactionId: json['transaction_id'],
      transactionReference: json['transaction_reference'],
      paymentMethod: json['payment_method'],
      paymentAttempt: json['payment_attempt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'possibleMerchants': possibleMerchants,
      'interestedMerchants': interestedMerchants?.map((e) => e.toJson()).toList(),
      'acceptedMerchant': acceptedMerchant,
      'requestStatus': requestStatus,
      'title': title,
      'category': category,
      'targetState': targetState,
      'targetAxis': targetAxis,
      'additionalDetails': additionalDetails,
      'requirements': requirements,
      'carHire': carHire?.toJson(),
      'cleaning': cleaning?.toJson(),
      'realEstate': realEstate?.toJson(),
      'carPart': carPart?.toJson(),
      'automobile': automobile?.toJson(),
      'transaction_id': transactionId,
      'transaction_reference': transactionReference,
      'payment_method': paymentMethod,
      'transaction_status': transactionStatus,
      'payment_attempt': paymentAttempt,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}


class CarHire {
  final String? carType;
  final int? hireDuration;
  final String? targetDrivingArea;
  final String? pickupLocation;
  final bool? airportPickup;
  final bool? travel;

  CarHire({
    this.carType,
    this.hireDuration,
    this.targetDrivingArea,
    this.pickupLocation,
    this.airportPickup,
    this.travel,
  });

  factory CarHire.fromJson(Map<String, dynamic> json) => CarHire(
    carType: json['carType'],
    hireDuration: json['hireDuration'],
    targetDrivingArea: json['targetDrivingArea'],
    pickupLocation: json['pickupLocation'],
    airportPickup: _parseBool(json['airport']),
    travel: _parseBool(json['travel']),
  );

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == 'yes' || lower == 'true';
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'carType': carType,
      'hireDuration': hireDuration,
      'targetDrivingArea': targetDrivingArea,
      'pickupLocation': pickupLocation,
      'airport': airportPickup,
      'travel': travel,
    };
  }
}

class Cleaning {
  final String? propertyType;
  final String? propertyLocation;
  final int? roomNumber;
  final String? cleaningType;

  Cleaning({
    this.propertyType,
    this.propertyLocation,
    this.roomNumber,
    this.cleaningType,
  });

  factory Cleaning.fromJson(Map<String, dynamic> json) {
    return Cleaning(
      propertyType: json['propertyType'],
      propertyLocation: json['propertyLocation'],
      roomNumber: int.tryParse(json['roomNumber'].toString()),
      cleaningType: json['cleaningType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyType': propertyType,
      'propertyLocation': propertyLocation,
      'roomNumber': roomNumber,
      'cleaningType': cleaningType,
    };
  }
}

class RealEstate {
  final String? type;
  final double? upperPriceLimit;
  final double? lowerPriceLimit;
  final String? propertyCondition;
  final String? propertyLocation;
  final String? propertyType;
  final String? roomCount;

  RealEstate({
    this.type,
    this.upperPriceLimit,
    this.lowerPriceLimit,
    this.propertyCondition,
    this.propertyLocation,
    this.propertyType,
    this.roomCount

  });

  factory RealEstate.fromJson(Map<String, dynamic> json) => RealEstate(
    type: json['rentType'],
    upperPriceLimit: (json['upperPriceLimit'] as num?)?.toDouble(),
    lowerPriceLimit: (json['lowerPriceLimit'] as num?)?.toDouble(),
    propertyCondition: json['propertyCondition'],
    propertyLocation: json['propertyLocation'],
    propertyType: json['propertyType'],
    roomCount: json['roomNumber'],
  );

  Map<String, dynamic> toJson() {
    return {
      'rentType': type,
      'upperPriceLimit': upperPriceLimit,
      'lowerPriceLimit': lowerPriceLimit,
      'propertyCondition': propertyCondition,
      'propertyLocation': propertyLocation,
      'propertyType': propertyType,
      'roomNumber': roomCount,
    };
  }
}

class CarPart {
  final String? currentLocation;
  final String? sourcingLocation;
  final String? carMake;
  final String? carModel;
  final int? carYear;
  final String? partDescription;
  final String? image;

  CarPart({
    this.currentLocation,
    this.sourcingLocation,
    this.carMake,
    this.carModel,
    this.carYear,
    this.partDescription,
    this.image,
  });

  factory CarPart.fromJson(Map<String, dynamic> json) => CarPart(
    currentLocation: json['currentLocation'],
    sourcingLocation: json['sourcingLocation'],
    carMake: json['carMake'],
    carModel: json['carModel'],
    carYear: json['carYear'],
    partDescription: json['partDescription'],
    image: json['image'],
  );

  Map<String, dynamic> toJson() {
    return {
      'currentLocation': currentLocation,
      'sourcingLocation': sourcingLocation,
      'carMake': carMake,
      'carModel': carModel,
      'carYear': carYear,
      'partDescription': partDescription,
      'image': image,
    };
  }
}

class Automobile {
  final String? state;
  final String? location;
  final String? carMake;
  final String? carModel;
  final int? carYearFrom;
  final int? carYearTo;
  final String? transmission;
  final double? upperPriceLimit;
  final double? lowerPriceLimit;
  final String? additionalDetails;



  Automobile({
    this.carMake,
    this.carModel,
    this.carYearFrom,
    this.carYearTo,
    this.transmission,
    this.upperPriceLimit,
    this.lowerPriceLimit,
    this.state,
    this.location,
    this.additionalDetails,
  });

  factory Automobile.fromJson(Map<String, dynamic> json) => Automobile(
    carMake: json['carMake'],
    carModel: json['carModel'],
    carYearFrom: json['carYearFrom'],
    carYearTo: json['carYearTo'],
    transmission: json['transmission'],
    upperPriceLimit: (json['upperPriceLimit'] as num?)?.toDouble(),
    lowerPriceLimit: (json['lowerPriceLimit'] as num?)?.toDouble(),
    state: json['state'],
    location: json['location'],
    additionalDetails: json['additionalDetails'],
  );

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'location': location,
      'carMake': carMake,
      'carModel': carModel,
      'carYearFrom': carYearFrom,
      'carYearTo': carYearTo,
      'transmission': transmission,
      'upperPriceLimit': upperPriceLimit,
      'lowerPriceLimit': lowerPriceLimit,
      'additionalDetails': additionalDetails,
    };
  }
}
