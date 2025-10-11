class HavadurumuModel {
  final String tarih;
  final String ikon;
  final String durum;
  final String derece;
  final String min;
  final String max;
  final String gece;
  final String nem;
  final String gun;

  HavadurumuModel(
    this.tarih,
    this.ikon,
    this.durum,
    this.derece,
    this.min,
    this.max,
    this.gece,
    this.nem,
    this.gun,
  );

  HavadurumuModel.fromjson(Map<String, dynamic> json)
    : tarih = json["date"],
      ikon = json["icon"],
      durum = json["description"],
      derece = json["degree"],
      min = json["min"],
      max = json["max"],
      gece = json["night"],
      nem = json["humidity"],
      gun = json["day"] ?? "";
}
