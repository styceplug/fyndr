import 'package:fyndr/models/user_model.dart';

class JobModel {
  String? id;
  Employer? employer;
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
  final String? id;
  final String? number;
  final String? email;
  final String? name;
  final String? avatar;

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
  String? companyImage;
  String? firstName;
  String? lastName;
  String? number;
  String? email;
  String? howYouHeardAboutUs;

  EmployerDetails({
    this.company,
    this.firstName,
    this.lastName,
    this.number,
    this.email,
    this.howYouHeardAboutUs,
    this.companyImage,
  });

  factory EmployerDetails.fromJson(Map<String, dynamic> json) {
    return EmployerDetails(
      company: json['company'],
      companyImage: json['companyImage'],
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
      "companyImage": companyImage,
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
  final String company;
  final String jobTitle;
  final String duration;

  WorkExperienceDetails({
    this.company = "",
    this.jobTitle = "",
    this.duration = "",
  });

  factory WorkExperienceDetails.fromJson(Map<String, dynamic> json) {
    return WorkExperienceDetails(
      company: json["company"]?.toString() ?? "",
      jobTitle: json["jobTitle"]?.toString() ?? "",
      duration: json["duration"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "company": company,
      "jobTitle": jobTitle,
      "duration": duration,
    };
  }
}

class Applicant {
  final String? cv;
  final UserModel? user;
  final String? proposal;

  Applicant({
    this.cv,
    this.user,
    this.proposal,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      cv: json['cv'] is Map<String, dynamic>
          ? CvModel.fromJson(json['cv']).id
          : json['cv']?.toString(),
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
      proposal: json['proposal'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "cv": cv,
      "user": user?.toJson(),
      "proposal": proposal,
    };
  }

}

class CvModel {
  final String id;
  final UserModel user;
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
  final List<WorkExperienceDetails> workExperienceDetails;
  final List<String> skills;
  final String additionalCertificate;
  final List<String> languages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? profileImage;

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
    this.profileImage,
  });

  factory CvModel.fromJson(Map<String, dynamic> json) {
    return CvModel(
      id: json["_id"]?.toString() ?? "",
      user: json["user"] is Map<String, dynamic>
          ? UserModel.fromJson(json["user"])
          : UserModel(),
      firstName: json["firstName"]?.toString() ?? "",
      lastName: json["lastName"]?.toString() ?? "",
      number: json["number"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      state: json["state"]?.toString() ?? "",
      lga: json["lga"]?.toString() ?? "",
      area: json["area"]?.toString() ?? "",
      isGraduate: json["isGraduate"] is bool ? json["isGraduate"] : false,
      educationDetails: json["educationDetails"] is Map<String, dynamic>
          ? EducationDetails.fromJson(json["educationDetails"])
          : EducationDetails(),
      hasWorkExperience:
      json["hasWorkExperience"] is bool ? json["hasWorkExperience"] : false,
      workExperienceDetails: json["workExperienceDetails"] is List
          ? List<WorkExperienceDetails>.from(
        json["workExperienceDetails"].map(
              (x) => WorkExperienceDetails.fromJson(x),
        ),
      )
          : [],
      skills: json["skills"] is List
          ? List<String>.from(json["skills"].map((x) => x.toString()))
          : [],
      additionalCertificate: json["additionalCertificate"]?.toString() ?? "",
      languages: json["languages"] is List
          ? List<String>.from(json["languages"].map((x) => x.toString()))
          : [],
      createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? "") ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"]?.toString() ?? "") ??
          DateTime.now(),
      profileImage: json["profileImage"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "user": user.toJson(),
      "firstName": firstName,
      "lastName": lastName,
      "number": number,
      "email": email,
      "state": state,
      "lga": lga,
      "area": area,
      "isGraduate": isGraduate,
      "educationDetails": educationDetails.toJson(),
      "hasWorkExperience": hasWorkExperience,
      "workExperienceDetails":
      workExperienceDetails.map((x) => x.toJson()).toList(),
      "skills": skills,
      "additionalCertificate": additionalCertificate,
      "languages": languages,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "profileImage": profileImage,
    };
  }
}
