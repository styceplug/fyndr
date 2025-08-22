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
  final Beauty? beauty;
  final Catering? catering;
  final Carpentry? carpentry;
  final Electrician? electrician;
  final IT? it;
  final Mechanic? mechanic;
  final Media? media;
  final Plumbing? plumbing;
  final Hospitality? hospitality;
  final EventManagement? eventManagement;




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
    this.beauty,
    this.catering,
    this.carpentry,
    this.electrician,
    this.it,
    this.mechanic,
    this.media,
    this.plumbing,
    this.hospitality,
    this.eventManagement,
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
      beauty:
          json['beauty'] != null ? Beauty.fromJson(json['beauty']) : null,
      catering:
          json['catering'] != null ? Catering.fromJson(json['catering']) : null,
      carpentry:
          json['carpentry'] != null ? Carpentry.fromJson(json['carpentry']) : null,
      electrician: json['electrician'] != null
          ? Electrician.fromJson(json['electrician'])
          : null,
      it:
          json['it'] != null ? IT.fromJson(json['it']) : null,
      mechanic:
          json['mechanic'] != null ? Mechanic.fromJson(json['mechanic']) : null,
      media:
          json['media'] != null ? Media.fromJson(json['media']) : null,
      plumbing:
          json['plumbing'] != null ? Plumbing.fromJson(json['plumbing']) : null,
      hospitality: json['hospitality'] != null
          ? Hospitality.fromJson(json['hospitality'])
          : null,
      eventManagement: json['eventManagement'] != null
          ? EventManagement.fromJson(json['eventManagement'])
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

class Beauty {
  final String? title;
  final String? state;
  final String? details;
  final String? targetLocation;
  final String? service;
  final DateTime? date;
  final DateTime? time;

  Beauty({
    this.title,
    this.state,
    this.details,
    this.targetLocation,
    this.service,
    this.date,
    this.time,
  });

  factory Beauty.fromJson(Map<String, dynamic> json) => Beauty(
    title: json['title'],
    state: json['state'],
    details: json['details'],
    targetLocation: json['targetLocation'],
    service: json['service'],
    date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
    time: json['time'] != null ? DateTime.tryParse(json['time']) : null,
  );


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'state': state,
      'details': details,
      'targetLocation': targetLocation,
      'service': service,
      'date': date?.toIso8601String(),
      'time': time?.toIso8601String(),
    };
  }

}

class Catering {
  final String? title;
  final String? state;
  final String? details;
  final String? location;
  final String? eventLocation;
  final DateTime? eventDate;

  Catering({
    this.title,
    this.state,
    this.details,
    this.location,
    this.eventLocation,
    this.eventDate,
  });

  factory Catering.fromJson(Map<String, dynamic> json) => Catering(
    title: json['title'],
    state: json['state'],
    details: json['details'],
    location: json['location'],
    eventLocation: json['eventLocation'],
    eventDate:
    json['eventDate'] != null ? DateTime.parse(json['eventDate']) : null,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'state': state,
    'details': details,
    'location': location,
    'eventLocation': eventLocation,
    'eventDate': eventDate?.toIso8601String(),
  };
}

class Carpentry {
  final String? title;
  final String? state;
  final String? details;
  final String? location;
  final DateTime? dateNeeded;

  Carpentry({
    this.title,
    this.state,
    this.details,
    this.location,
    this.dateNeeded,
  });

  factory Carpentry.fromJson(Map<String, dynamic> json) => Carpentry(
    title: json['title'],
    state: json['state'],
    details: json['details'],
    location: json['location'],
    dateNeeded:
    json['dateNeeded'] != null ? DateTime.parse(json['dateNeeded']) : null,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'state': state,
    'details': details,
    'location': location,
    'dateNeeded': dateNeeded?.toIso8601String(),
  };
}

class Electrician {
  final String? title;
  final String? state;
  final String? details;
  final String? location;
  final DateTime? dateNeeded;

  Electrician({
    this.title,
    this.state,
    this.details,
    this.location,
    this.dateNeeded,
  });

  factory Electrician.fromJson(Map<String, dynamic> json) => Electrician(
    title: json['title'],
    state: json['state'],
    details: json['details'],
    location: json['location'],
    dateNeeded:
    json['dateNeeded'] != null ? DateTime.parse(json['dateNeeded']) : null,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'state': state,
    'details': details,
    'location': location,
    'dateNeeded': dateNeeded?.toIso8601String(),
  };
}

class IT {
  final String? title;
  final String? state;
  final String? details;
  final String? targetLocation;
  final String? service;

  IT({
    this.title,
    this.state,
    this.details,
    this.targetLocation,
    this.service,
  });

  factory IT.fromJson(Map<String, dynamic> json) => IT(
    title: json['title'],
    state: json['state'],
    details: json['details'],
    targetLocation: json['targetLocation'],
    service: json['service'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'state': state,
    'details': details,
    'targetLocation': targetLocation,
    'service': service,
  };
}

class Mechanic {
  final String? title;
  final String? state;
  final String? details;
  final String? currentLocation;
  final String? carMake;
  final String? carModel;
  final int? carYear;
  final String? transmission;

  Mechanic({
    this.title,
    this.state,
    this.details,
    this.currentLocation,
    this.carMake,
    this.carModel,
    this.carYear,
    this.transmission,
  });

  factory Mechanic.fromJson(Map<String, dynamic> json) => Mechanic(
    title: json['title'],
    state: json['state'],
    details: json['details'],
    currentLocation: json['currentLocation'],
    carMake: json['carMake'],
    carModel: json['carModel'],
    carYear: json['carYear'],
    transmission: json['transmission'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'state': state,
    'details': details,
    'currentLocation': currentLocation,
    'carMake': carMake,
    'carModel': carModel,
    'carYear': carYear,
    'transmission': transmission,
  };
}

class Media {
  final String? title;
  final String? state;
  final String? details;
  final String? targetLocation;
  final String? service;

  Media({
    this.title,
    this.state,
    this.details,
    this.targetLocation,
    this.service,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    title: json['title'],
    state: json['state'],
    details: json['details'],
    targetLocation: json['targetLocation'],
    service: json['service'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'state': state,
    'details': details,
    'targetLocation': targetLocation,
    'service': service,
  };
}

class Plumbing {
  final String? title;
  final String? state;
  final String? details;
  final String? location;
  final DateTime? dateNeeded;

  Plumbing({
    this.title,
    this.state,
    this.details,
    this.location,
    this.dateNeeded,
  });

  factory Plumbing.fromJson(Map<String, dynamic> json) => Plumbing(
    title: json['title'],
    state: json['state'],
    details: json['details'],
    location: json['location'],
    dateNeeded:
    json['dateNeeded'] != null ? DateTime.parse(json['dateNeeded']) : null,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'state': state,
    'details': details,
    'location': location,
    'dateNeeded': dateNeeded?.toIso8601String(),
  };
}

class Hospitality {
  final String? title;
  final String? state;
  final String? details;
  final String? location;
  final String? service;
  final DateTime? dateNeeded;
  final String? timeNeeded;

  Hospitality({
    this.title,
    this.state,
    this.details,
    this.location,
    this.service,
    this.dateNeeded,
    this.timeNeeded,
  });

  factory Hospitality.fromJson(Map<String, dynamic> json) => Hospitality(
    title: json['title'],
    state: json['state'],
    details: json['details'],
    location: json['location'],
    service: json['service'],
    dateNeeded: json['dateNeeded'] != null
        ? DateTime.parse(json['dateNeeded'])
        : null,
    timeNeeded: json['timeNeeded'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'state': state,
    'details': details,
    'location': location,
    'service': service,
    'dateNeeded': dateNeeded?.toIso8601String(),
    'timeNeeded': timeNeeded,
  };
}

class EventManagement {
  final String? title;
  final String? state;
  final String? details;
  final String? location;
  final String? service;
  final String? eventLocation;
  final DateTime? dateNeeded;

  EventManagement({
    this.title,
    this.state,
    this.details,
    this.location,
    this.service,
    this.eventLocation,
    this.dateNeeded,
  });

  factory EventManagement.fromJson(Map<String, dynamic> json) => EventManagement(
    title: json['title'],
    state: json['state'],
    details: json['details'],
    location: json['location'],
    service: json['service'],
    eventLocation: json['eventLocation'],
    dateNeeded: json['dateNeeded'] != null
        ? DateTime.parse(json['dateNeeded'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'state': state,
    'details': details,
    'location': location,
    'service': service,
    'eventLocation': eventLocation,
    'dateNeeded': dateNeeded?.toIso8601String(),
  };
}




