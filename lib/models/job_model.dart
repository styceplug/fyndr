class JobModel {
  String? id;
  Employer? employer; // ✅ FIXED
  EmployerDetails? employerDetails;
  JobDetails? jobDetails;
  List<Applicant>? applicants;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  JobModel({
    this.id,
    this.employer,
    this.employerDetails,
    this.jobDetails,
    this.applicants,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'],
      employer: json['employer'] != null
          ? Employer.fromJson(json['employer'])
          : null,
      employerDetails: json['employerDetails'] != null
          ? EmployerDetails.fromJson(json['employerDetails'])
          : null,
      jobDetails: json['jobDetails'] != null
          ? JobDetails.fromJson(json['jobDetails'])
          : null,
      applicants: json['applicants'] != null
          ? List<Applicant>.from(
          json['applicants'].map((x) => Applicant.fromJson(x)))
          : [],
      status: json['status'],
      createdAt:
      json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
      json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "employer": employer?.toJson(),
      "employerDetails": employerDetails?.toJson(),
      "jobDetails": jobDetails?.toJson(),
      "applicants": applicants?.map((x) => x.toJson()).toList(),
      "status": status,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}

class Employer {
  String? id;
  String? number;
  String? email;
  String? name;
  String? avatar;

  Employer({
    this.id,
    this.number,
    this.email,
    this.name,
    this.avatar,
  });

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      id: json['_id'],
      number: json['number'],
      email: json['email'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "number": number,
      "email": email,
      "name": name,
      "avatar": avatar,
    };
  }
}

class EmployerDetails {
  String? company;
  String? firstName;
  String? lastName;
  String? number;
  String? email;

  EmployerDetails({
    this.company,
    this.firstName,
    this.lastName,
    this.number,
    this.email,
  });

  factory EmployerDetails.fromJson(Map<String, dynamic> json) {
    return EmployerDetails(
      company: json['company'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      number: json['number'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "company": company,
      "firstName": firstName,
      "lastName": lastName,
      "number": number,
      "email": email,
    };
  }
}

class JobDetails {
  String? title;
  String? location;
  String? type;
  String? startDate;
  int? salary;
  String? salaryCurrency;
  List<String>? benefits;
  String? description;
  String? availableVacancy;

  JobDetails({
    this.title,
    this.location,
    this.type,
    this.startDate,
    this.salary,
    this.salaryCurrency,
    this.benefits,
    this.description,
    this.availableVacancy,
  });

  factory JobDetails.fromJson(Map<String, dynamic> json) {
    return JobDetails(
      title: json['title'],
      location: json['location'],
      type: json['type'],
      startDate: json['startDate'],
      salary: json['salary'],
      salaryCurrency: json['salaryCurrency'],
      benefits: json['benefits'] != null
          ? List<String>.from(json['benefits'])
          : [],
      description: json['description'],
      availableVacancy: json['availableVacancy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "location": location,
      "type": type,
      "startDate": startDate,
      "salary": salary,
      "salaryCurrency": salaryCurrency,
      "benefits": benefits,
      "description": description,
      "availableVacancy": availableVacancy,
    };
  }
}

class Applicant {
  String? user;
  String? firstName;
  String? lastName;
  String? number;
  String? email;
  String? state;
  String? lga;
  String? area;
  bool? isGraduate;
  EducationDetails? educationDetails;
  bool? hasWorkExperience;
  WorkExperienceDetails? workExperienceDetails;
  List<String>? skills;
  String? additionalCertificate;
  List<String>? languages;

  Applicant({
    this.user,
    this.firstName,
    this.lastName,
    this.number,
    this.email,
    this.state,
    this.lga,
    this.area,
    this.isGraduate,
    this.educationDetails,
    this.hasWorkExperience,
    this.workExperienceDetails,
    this.skills,
    this.additionalCertificate,
    this.languages,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      user: json['user'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      number: json['number'],
      email: json['email'],
      state: json['state'],
      lga: json['lga'],
      area: json['area'],
      isGraduate: json['isGraduate'],
      educationDetails: json['educationDetails'] != null
          ? EducationDetails.fromJson(json['educationDetails'])
          : null,
      hasWorkExperience: json['hasWorkExperience'],
      workExperienceDetails: json['workExperienceDetails'] != null
          ? WorkExperienceDetails.fromJson(json['workExperienceDetails'])
          : null,
      skills:
      json['skills'] != null ? List<String>.from(json['skills']) : [],
      additionalCertificate: json['additionalCertificate'],
      languages:
      json['languages'] != null ? List<String>.from(json['languages']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user,
      "firstName": firstName,
      "lastName": lastName,
      "number": number,
      "email": email,
      "state": state,
      "lga": lga,
      "area": area,
      "isGraduate": isGraduate,
      "educationDetails": educationDetails?.toJson(),
      "hasWorkExperience": hasWorkExperience,
      "workExperienceDetails": workExperienceDetails?.toJson(),
      "skills": skills,
      "additionalCertificate": additionalCertificate,
      "languages": languages,
    };
  }
}

class EducationDetails {
  String? educationLevel;
  String? educationMajor;
  String? schoolName;
  String? startYear;
  String? endYear;

  EducationDetails({
    this.educationLevel,
    this.educationMajor,
    this.schoolName,
    this.startYear,
    this.endYear,
  });

  factory EducationDetails.fromJson(Map<String, dynamic> json) {
    return EducationDetails(
      educationLevel: json['educationLevel'],
      educationMajor: json['educationMajor'],
      schoolName: json['schoolName'],
      startYear: json['startYear'],
      endYear: json['endYear'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "educationLevel": educationLevel,
      "educationMajor": educationMajor,
      "schoolName": schoolName,
      "startYear": startYear,
      "endYear": endYear,
    };
  }
}

class WorkExperienceDetails {
  String? years;
  String? company;
  String? jobTitle;
  String? duration;

  WorkExperienceDetails({
    this.years,
    this.company,
    this.jobTitle,
    this.duration,
  });

  factory WorkExperienceDetails.fromJson(Map<String, dynamic> json) {
    return WorkExperienceDetails(
      years: json['years'],
      company: json['company'],
      jobTitle: json['jobTitle'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "years": years,
      "company": company,
      "jobTitle": jobTitle,
      "duration": duration,
    };
  }
}

class CvModel {
  final String id;
  final String user;
  final String firstName;
  final String lastName;
  final String number;
  final String email;
  final String state;
  final String lga;
  final String area;
  final bool isGraduate;
  final EducationDetails educationDetails;
  final bool hasWorkExperience;
  final WorkExperienceDetails workExperienceDetails;
  final List<String> skills;
  final String additionalCertificate;
  final List<String> languages;
  final DateTime createdAt;
  final DateTime updatedAt;

  CvModel({
    required this.id,
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.number,
    required this.email,
    required this.state,
    required this.lga,
    required this.area,
    required this.isGraduate,
    required this.educationDetails,
    required this.hasWorkExperience,
    required this.workExperienceDetails,
    required this.skills,
    required this.additionalCertificate,
    required this.languages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CvModel.fromJson(Map<String, dynamic> json) {
    return CvModel(
      id: json["_id"] ?? "",
      user: json["user"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      number: json["number"] ?? "",
      email: json["email"] ?? "",
      state: json["state"] ?? "",
      lga: json["lga"] ?? "",
      area: json["area"] ?? "",
      isGraduate: json["isGraduate"] ?? false,
      educationDetails: EducationDetails.fromJson(json["educationDetails"] ?? {}),
      hasWorkExperience: json["hasWorkExperience"] ?? false,
      workExperienceDetails: WorkExperienceDetails.fromJson(json["workExperienceDetails"] ?? {}),
      skills: List<String>.from(json["skills"] ?? []),
      additionalCertificate: json["additionalCertificate"] ?? "",
      languages: List<String>.from(json["languages"] ?? []),
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
    );
  }
}

