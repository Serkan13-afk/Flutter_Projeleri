class Kisi {
  late String id;
  late String ad;
  late String soyad;
  late String mail;
  late String sifre;

  Kisi(this.id, this.ad, this.soyad, this.mail, this.sifre);

  factory Kisi.fromJson(Map<String, dynamic> json) {
    return Kisi(
      json["id"] as String,
      json["ad"] as String,
      json["soyad"] as String,
      json["mail"] as String,
      json["sifre"] as String,
    );
  }
}
