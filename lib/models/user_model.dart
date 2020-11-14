class UserModel {
  //TODO: check for place, frequency datatype
  final String phoneNumber, name, email, place, frequency;
  final DateTime dateOfBirth;
  UserModel({
    this.phoneNumber,
    this.name,
    this.email,
    this.frequency,
    this.place,
    this.dateOfBirth,
  });
}
