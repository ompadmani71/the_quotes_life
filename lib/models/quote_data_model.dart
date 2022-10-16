
import 'dart:convert';

List<Quote> quoteFromJson(String str) => List<Quote>.from(json.decode(str).map((x) => Quote.fromJson(x)));
List<Quote> quoteFromJsonDatabase(String str) => List<Quote>.from(json.decode(str).map((x) => Quote.fromJsonDatabase(x)));


class Quote {
  Quote({
    this.id,
    required this.quote,
    required this.author,
    this.category,
    this.isLike,
    this.imageIndex
  });

  int? id;
  String quote;
  String author;
  Category? category;
  String? isLike;
  int? imageIndex;

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
    quote: json["quote"],
    author: json["author"],
    category: categoryValues.map[json["category"]],
  );
  factory Quote.fromJsonDatabase(Map<String, dynamic> json) => Quote(
    id: json["id"],
    quote: json["quotes"],
    author: json["author"],
    category: categoryValues.map[json["category"]],
    isLike: json["is_like"],
    imageIndex: json["image_index"]
  );

  Map<String, dynamic> toJson() => {
    "quote": quote,
    "author": author,
    "category": categoryValues.reverse[category],
  };
}

enum Category { Age, Alone, Amazing, Anger, Architecture, Art, Attitude, Beauty, Best, Birthday, Business, Car, Change, Computers, Cool, Courage, Dad, Dating, Death, Design, Dreams }

final categoryValues = EnumValues({
  "age": Category.Age,
  "alone": Category.Alone,
  "amazing": Category.Amazing,
  "anger": Category.Anger,
  "architecture": Category.Architecture,
  "art": Category.Art,
  "attitude": Category.Attitude,
  "beauty": Category.Beauty,
  "best": Category.Best,
  "birthday": Category.Birthday,
  "business": Category.Business,
  "car": Category.Car,
  "change": Category.Change,
  "computers": Category.Computers,
  "cool": Category.Cool,
  "courage": Category.Courage,
  "dad": Category.Dad,
  "dating": Category.Dating,
  "death": Category.Death,
  "design": Category.Design,
  "dreams": Category.Dreams
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}
