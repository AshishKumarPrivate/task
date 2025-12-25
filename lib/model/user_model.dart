class UserListModel {
  final String firstName;
  final String lastName;
  final String email;
  final String thumbnail;
  final String largePicture;
  final String gender;
  final String phone;
  final String city;
  final String state;
  final String country;
  final DateTime dob;
  final int age;
  final String nat;

  UserListModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.thumbnail,
    required this.largePicture,
    required this.gender,
    required this.phone,
    required this.city,
    required this.state,
    required this.country,
    required this.dob,
    required this.age,
    required this.nat,
  });

  factory UserListModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final picture = json['picture'];
    final location = json['location'];
    final dobData = json['dob'];

    return UserListModel(
      firstName: name['first'],
      lastName: name['last'],
      email: json['email'],
      thumbnail: picture['thumbnail'],
      largePicture: picture['large'],
      gender: json['gender'],
      phone: json['phone'],
      city: location['city'],
      state: location['state'],
      country: location['country'],
      dob: DateTime.parse(dobData['date']),
      age: dobData['age'],
      nat: json['nat'],
    );
  }

  String get fullName => '$firstName $lastName';
}