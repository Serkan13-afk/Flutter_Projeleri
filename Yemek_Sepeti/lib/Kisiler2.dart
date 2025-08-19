
class Kisiler2 {
  late String ad;
  late String soyad;
  late String mail;
  late String sifre;
  late String siparisAdres;
  late bool premiumVarmi;

  Kisiler2(
      this.ad,
      this.mail,
      this.premiumVarmi,
      this.sifre,
      this.siparisAdres,
      this.soyad,
      );

  factory Kisiler2.fromJson(Map<dynamic, dynamic> json) {
    return Kisiler2(
      json["ad"] as String,
      json["mail"] as String,
      json["premiumVarmi"] as bool,
      json["sifre"] as String,
      json["siparis_Adres"] as String,
      json["soyad"] as String,


    );
  }
}
