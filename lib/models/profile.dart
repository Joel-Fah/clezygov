class Profile {
  final String uid;
  final String role;
  final String? fullName;
  final String? occupation;
  final String? residence;
  final String? gender;
  final String? phoneNumber;
  final List<String>? interests;

  Profile({
    this.fullName,
    this.occupation,
    this.residence,
    this.gender,
    this.phoneNumber,
    this.interests,
    required this.uid,
    required this.role,
  });

  factory Profile.fromJson(Map<String, dynamic> data) {
    return Profile(
      uid: data['uid'],
      role: data['role'],
      fullName: data['fullName'],
      occupation: data['occupation'],
      residence: data['residence'],
      phoneNumber: data['phoneNumber'],
      gender: data['gender'],
      interests: List<String>.from(data['interests']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'role': role,
      'fullName': fullName,
      'occupation': occupation,
      'residence': residence,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'interests': interests,
    };
  }

  // toString
  @override
  String toString() {
    return 'uid: $uid, role: $role, fullName: $fullName, occupation: $occupation, phoneNumber:$phoneNumber, gender: $gender, interests: $interests'; 
  }
}
