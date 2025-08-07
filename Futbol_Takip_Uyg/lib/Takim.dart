class Takim {
  final String? idTakim;
  final String? idESPN;
  final String? idAPIfootball;
  final String? sevilenSayisi;
  final String? takimAdi;
  final String? takimAdiAlternatif;
  final String? takimKisaAdi;
  final String? kurulusYili;
  final String? sporTuru;
  final String? ligi;
  final String? idLigi;
  final String? ligi2;
  final String? idLigi2;
  final String? ligi3;
  final String? idLigi3;
  final String? ligi4;
  final String? idLigi4;
  final String? ligi5;
  final String? idLigi5;
  final String? ligi6;
  final String? idLigi6;
  final String? ligi7;
  final String? idLigi7;
  final String? bolum;
  final String? idSaha;
  final String? stad;
  final String? anahtarKelimeler;
  final String? rss;
  final String? lokasyon;
  final String? stadKapasitesi;
  final String? websitesi;
  final String? facebook;
  final String? twitter;
  final String? instagram;
  final String? aciklamaEN;
  final String? aciklamaDE;
  final String? aciklamaFR;
  final String? aciklamaCN;
  final String? aciklamaIT;
  final String? aciklamaJP;
  final String? aciklamaRU;
  final String? aciklamaES;
  final String? aciklamaPT;
  final String? aciklamaSE;
  final String? aciklamaNL;
  final String? aciklamaHU;
  final String? aciklamaNO;
  final String? aciklamaIL;
  final String? aciklamaPL;
  final String? renk1;
  final String? renk2;
  final String? renk3;
  final String? cinsiyet;
  final String? ulke;
  final String? armasi;
  final String? logosu;
  final String? fanart1;
  final String? fanart2;
  final String? fanart3;
  final String? fanart4;
  final String? banner;
  final String? ekipman;
  final String? youtube;
  final String? kilitli;

  Takim({
    this.idTakim,
    this.idESPN,
    this.idAPIfootball,
    this.sevilenSayisi,
    this.takimAdi,
    this.takimAdiAlternatif,
    this.takimKisaAdi,
    this.kurulusYili,
    this.sporTuru,
    this.ligi,
    this.idLigi,
    this.ligi2,
    this.idLigi2,
    this.ligi3,
    this.idLigi3,
    this.ligi4,
    this.idLigi4,
    this.ligi5,
    this.idLigi5,
    this.ligi6,
    this.idLigi6,
    this.ligi7,
    this.idLigi7,
    this.bolum,
    this.idSaha,
    this.stad,
    this.anahtarKelimeler,
    this.rss,
    this.lokasyon,
    this.stadKapasitesi,
    this.websitesi,
    this.facebook,
    this.twitter,
    this.instagram,
    this.aciklamaEN,
    this.aciklamaDE,
    this.aciklamaFR,
    this.aciklamaCN,
    this.aciklamaIT,
    this.aciklamaJP,
    this.aciklamaRU,
    this.aciklamaES,
    this.aciklamaPT,
    this.aciklamaSE,
    this.aciklamaNL,
    this.aciklamaHU,
    this.aciklamaNO,
    this.aciklamaIL,
    this.aciklamaPL,
    this.renk1,
    this.renk2,
    this.renk3,
    this.cinsiyet,
    this.ulke,
    this.armasi,
    this.logosu,
    this.fanart1,
    this.fanart2,
    this.fanart3,
    this.fanart4,
    this.banner,
    this.ekipman,
    this.youtube,
    this.kilitli,
  });

  factory Takim.fromJson(Map<String, dynamic> json) {
    return Takim(
      idTakim: json["idTeam"],
      idESPN: json["idESPN"],
      idAPIfootball: json["idAPIfootball"],
      sevilenSayisi: json["intLoved"],
      takimAdi: json["strTeam"],
      takimAdiAlternatif: json["strTeamAlternate"],
      takimKisaAdi: json["strTeamShort"],
      kurulusYili: json["intFormedYear"],
      sporTuru: json["strSport"],
      ligi: json["strLeague"],
      idLigi: json["idLeague"],
      ligi2: json["strLeague2"],
      idLigi2: json["idLeague2"],
      ligi3: json["strLeague3"],
      idLigi3: json["idLeague3"],
      ligi4: json["strLeague4"],
      idLigi4: json["idLeague4"],
      ligi5: json["strLeague5"],
      idLigi5: json["idLeague5"],
      ligi6: json["strLeague6"],
      idLigi6: json["idLeague6"],
      ligi7: json["strLeague7"],
      idLigi7: json["idLeague7"],
      bolum: json["strDivision"],
      idSaha: json["idVenue"],
      stad: json["strStadium"],
      anahtarKelimeler: json["strKeywords"],
      rss: json["strRSS"],
      lokasyon: json["strLocation"],
      stadKapasitesi: json["intStadiumCapacity"],
      websitesi: json["strWebsite"],
      facebook: json["strFacebook"],
      twitter: json["strTwitter"],
      instagram: json["strInstagram"],
      aciklamaEN: json["strDescriptionEN"],
      aciklamaDE: json["strDescriptionDE"],
      aciklamaFR: json["strDescriptionFR"],
      aciklamaCN: json["strDescriptionCN"],
      aciklamaIT: json["strDescriptionIT"],
      aciklamaJP: json["strDescriptionJP"],
      aciklamaRU: json["strDescriptionRU"],
      aciklamaES: json["strDescriptionES"],
      aciklamaPT: json["strDescriptionPT"],
      aciklamaSE: json["strDescriptionSE"],
      aciklamaNL: json["strDescriptionNL"],
      aciklamaHU: json["strDescriptionHU"],
      aciklamaNO: json["strDescriptionNO"],
      aciklamaIL: json["strDescriptionIL"],
      aciklamaPL: json["strDescriptionPL"],
      renk1: json["strColour1"],
      renk2: json["strColour2"],
      renk3: json["strColour3"],
      cinsiyet: json["strGender"],
      ulke: json["strCountry"],
      armasi: json["strBadge"],
      logosu: json["strLogo"],
      fanart1: json["strFanart1"],
      fanart2: json["strFanart2"],
      fanart3: json["strFanart3"],
      fanart4: json["strFanart4"],
      banner: json["strBanner"],
      ekipman: json["strEquipment"],
      youtube: json["strYoutube"],
      kilitli: json["strLocked"],
    );
  }
}
