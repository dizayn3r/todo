class UserModel {
  String uid;
  String? email;
  String? displayName;
  String? phoneNumber;
  String? photoUrl;

  UserModel(
      {required this.uid,
        this.email,
        this.displayName,
        this.phoneNumber,
        this.photoUrl});

}