import 'dart:convert';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

String reportToJson(Report data) => json.encode(data.toJson());

class Report {
  Report({
    this.userId,
    this.dateTime,
    this.characterName,
  });

  int userId;
  String dateTime;
  String characterName;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        userId: json["userId"],
        dateTime: json["dateTime"],
        characterName: json["character_name"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "dateTime": dateTime,
        "character_name": characterName,
      };
}
