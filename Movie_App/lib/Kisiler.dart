class Kisiler {
  late String? kisiAd;
  late String? kisiSoyad;
  late String? kisiMail;
  late String? kisiSifre;
  late String? kisiprofilUrl;
  late bool? kisipremiumVarMi;
  late String? kisiStory;

  Kisiler(
    this.kisiAd,
    this.kisiMail,
    this.kisiSifre,
    this.kisiSoyad,
    this.kisiStory,
    this.kisiprofilUrl,
    this.kisipremiumVarMi,
  );

  factory Kisiler.fromJson(Map<dynamic, dynamic> json) {
    return Kisiler(
      json["kisiAd"] as String,
      json["kisiMail"] as String,
      json["kisiSifre"] as String,
      json["kisiSoyad"] as String,
      json["kisiStory"] as String,
      json["kisiprofilUrl"] as String,
      json["kisipremiumVarMi"] as bool,
    );
  }
}
