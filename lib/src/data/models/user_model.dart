class UserModel {
  String uid;
  String email;
  int? age;
  double? weight;
  String? gender;
  double? waterIntake;
  bool isOnboardingComplete;

  UserModel({
    required this.uid,
    required this.email,
    this.age,
    this.weight,
    this.gender,
    this.waterIntake,
    this.isOnboardingComplete = false,
  });

  // Convert a UserModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'age': age,
      'weight': weight,
      'gender': gender,
      'waterIntake': waterIntake,
      'isOnboardingComplete': isOnboardingComplete,
    };
  }

  // Create a UserModel from a Firestore document snapshot
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      age: map['age'],
      weight: map['weight'],
      gender: map['gender'],
      waterIntake: map['waterIntake'],
      isOnboardingComplete: map['isOnboardingComplete'] ?? false,
    );
  }
}
