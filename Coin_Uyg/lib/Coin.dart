class Coin {
  late String isim;
  late String gorsel;
  late double fiyat;

  Coin(this.isim, this.gorsel, this.fiyat);

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      json['name'] as String,          // ✅ "isim" değil, "name"
      json['image'] as String,         // ✅ "gorsel" değil, "image"
      (json['current_price'] as num).toDouble(), // ✅ "fiyat" değil, "current_price"
    );
  }
}

