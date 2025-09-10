class UserModel {
  final String userID;
  final String fName;
  final String lName;
  final String email;


  UserModel({required this.userID, required this.fName, required this.lName, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'fName': fName,
      'lName': lName,
      'email' : email
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userID: map['title'] ?? '',
      fName: map['content'] ?? '',
      lName: map['contentLink'] ?? '',
      email: map['email'] ?? ''
    );
  }
}