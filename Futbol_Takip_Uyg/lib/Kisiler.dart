class Kisiler {
  late String kulaniciAdi;
  late String sifre;

  Kisiler(this.kulaniciAdi, this.sifre);

  factory Kisiler.fromJson(Map<dynamic, dynamic> json) {
    return Kisiler(json["kulaniciAdi"] as String, json["sifre"] as String);
  }
}