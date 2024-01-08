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
        id: json["id"].toString(),
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
    String? name,
    String? image,
    String? id,
    String? categoryId,
    String? price,
    String? description,
    String? size,
    String? temperature,
    String? humidity,
    String? rating,
    String? color,
  }) =>
      ProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        categoryId: categoryId ?? this.categoryId,
        description: description ?? this.description,
        isFavourite: false,
        price: price != null ? double.parse(price) : this.price,
        image: image ?? this.image,
        qty: 1,
        size: size ?? this.size,
        temperature: temperature ?? this.temperature,
        humidity: humidity ?? this.humidity,
        rating: rating ?? this.rating,
        color: color ?? this.color,
      );
}
