import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.profilePhotoURL,
    required this.userId,
    required this.firstName,
    required this.lastName,
    // this.notificationToken,
    required this.email,
    required this.City,
    required this.budget,
    required this.category,
    required this.gardenSize,
    required this.isAdmin,
    required this.phoneNumber,
  });

  String? profilePhotoURL;

  String email;
  String firstName;
  String lastName;
  String userId;
  // String? notificationToken;
  String City;
  int budget;
  String category;
  String gardenSize;
  bool isAdmin;
  String phoneNumber;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["user_id"],
        profilePhotoURL: json["profile_photo_url"],
        // notificationToken: json["notificationToken"] ?? "",
        budget: int.parse(json["budget"].toString()),
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        City: json["City"],
        category: json["category"],
        gardenSize: json["garden_size"],
        isAdmin: false,
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "profile_photo_url": profilePhotoURL,
        "first_name": firstName,
        "last_name": lastName,
        // "notificationToken": notificationToken,
        "budget": budget,
        "email": email,
        "City": City,
        "category": category,
        "garden_size": gardenSize,
        "isAdmin": isAdmin,
        "phone_number": phoneNumber,
      };

  UserModel copyWith({
    String? firstName,
    String? lastName,
    profilePhotoURL,
  }) =>
      UserModel(
        userId: userId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        profilePhotoURL: profilePhotoURL ?? this.profilePhotoURL,
        email: email,
        City: City,
        budget: budget,
        category: category,
        gardenSize: gardenSize,
        isAdmin: isAdmin,
        phoneNumber: phoneNumber,
      );
}
