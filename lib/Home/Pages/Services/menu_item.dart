class Items {
  String? price;
  String? name;
  String? type;
  Items({this.price, this.name, this.type});

  factory Items.fromMap(map) {
    return Items(
      price: map['price'],
      name: map['name'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'price': price,
      'name': name,
    };
  }
}
