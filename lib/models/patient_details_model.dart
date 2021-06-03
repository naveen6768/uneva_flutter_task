// // To parse this JSON data, do
// //
// //     final patientDetails = patientDetailsFromJson(jsonString);

import 'dart:convert';

PatientDetails patientDetailsFromJson(String str) =>
    PatientDetails.fromJson(json.decode(str));

String patientDetailsToJson(PatientDetails data) => json.encode(data.toJson());

class PatientDetails {
  PatientDetails({
    required this.personFullName,
    required this.personGender,
    required this.personPic,
    required this.personAge,
    required this.personPhone,
    required this.personPid,
    required this.personRelation,
    required this.personAddress,
    required this.personOccupation,
    required this.personCaption,
    required this.pk,
  });

  final dynamic personFullName;
  final dynamic personGender;
  final dynamic personPic;
  final dynamic personAge;
  final dynamic personPhone;
  final dynamic personPid;
  final dynamic personRelation;
  final dynamic personAddress;
  final dynamic personOccupation;
  final dynamic personCaption;
  final dynamic pk;

  factory PatientDetails.fromJson(Map<String, dynamic> json) => PatientDetails(
        personFullName: json["person_full_name"],
        personGender: json["person_gender"],
        personPic: json["person_pic"],
        personAge: json["person_age"],
        personPhone: json["person_phone"],
        personPid: json["person_pid"],
        personRelation: json["person_relation"],
        personAddress: json["person_address"],
        personOccupation: json["person_occupation"],
        personCaption: json["person_caption"],
        pk: json["_pk"],
      );

  Map<String, dynamic> toJson() => {
        "person_full_name": personFullName,
        "person_gender": personGender,
        "person_pic": personPic,
        "person_age": personAge,
        "person_phone": personPhone,
        "person_pid": personPid,
        "person_relation": personRelation,
        "person_address": personAddress,
        "person_occupation": personOccupation,
        "person_caption": personCaption,
        "_pk": pk,
      };
}
