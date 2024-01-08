import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel(
      {required this.image,
      required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.categoryId,
      required this.isFavourite,
      required this.size,
      required this.temperature,
      required this.humidity,
      required this.rating,
      required this.color,
      this.qty});

  String image;
  String id, categoryId;
  bool isFavourite;
  String name;
  double price;
  String description;
  String size;
  String temperature;
  String humidity;
  String rating;
  String color;
  int? qty;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        categoryId: json["categoryId"] ?? "",
        isFavourite: false,
        qty: json["qty"],
        price: double.parse(json["price"].toString()),
        size: json["size"],
        temperature: json["temperature"],
        humidity: json["humidity"],
        rating: json["rating"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "isFavourite": isFavourite,
        "price": price,
        "categoryId": categoryId,
        "qty": qty,
        "size": size,
        "temperature": temperature,
        "humidity": humidity,
        "rating": rating,
        "color": color,
      };
  ProductModel copyWith({
    int? qty,
  }) =>
      ProductModel(
        id: id,
        name: name,
        categoryId: categoryId,
        description: description,
        image: image,
        isFavourite: isFavourite,
        qty: qty ?? this.qty,
        price: price,
        size: size,
        temperature: temperature,
        humidity: humidity,
        rating: rating,
        color: color,
      );
}
