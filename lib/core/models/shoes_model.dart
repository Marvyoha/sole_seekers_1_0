class Item {
  final int id;
  final String image;
  final String description;
  final int price;
  final String gender;
  final String brand;
  final String name;

  Item(
      {required this.id,
      required this.image,
      required this.description,
      required this.price,
      required this.gender,
      required this.brand,
      required this.name});

  Item.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as int,
          price: json['price']! as int,
          name: json['name']! as String,
          image: json['image']! as String,
          description: json['description']! as String,
          gender: json['gender']! as String,
          brand: json['brand']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'price': price,
      'name': name,
      'image': image,
      'description': description,
      'gender': gender,
      'brand': brand,
    };
  }
}
