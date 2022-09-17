class Animal {
  late String id;
  late String name;
  late String image;
  late String about;

  Animal(
      {required this.id,
      required this.image,
      required this.name,
      required this.about});

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
        id: json["ID"],
        image: json["Image"],
        name: json["Name"],
        about: json['About']);
  }
}
