class Profile {
  final String uid;
  final String role;

  Profile({
    required this.uid,
    required this.role,
  });

  factory Profile.fromJson(Map<String, dynamic> data) {
    return Profile(
      uid: data['uid'],
      role: data['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'role': role,
    };
  }
}