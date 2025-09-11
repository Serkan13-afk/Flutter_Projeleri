// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get giris_yap {
    return Intl.message('Login', name: 'giris_yap', desc: '', args: []);
  }

  /// `Register`
  String get kayit_yap {
    return Intl.message('Register', name: 'kayit_yap', desc: '', args: []);
  }

  /// `Enter your email address`
  String get mail_adresi_gir_giris {
    return Intl.message(
      'Enter your email address',
      name: 'mail_adresi_gir_giris',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get sifre_gir_giris {
    return Intl.message(
      'Enter your password',
      name: 'sifre_gir_giris',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get sifrenimi_unuttun {
    return Intl.message(
      'Forgot your password?',
      name: 'sifrenimi_unuttun',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get adini_gir_kayit {
    return Intl.message(
      'Enter your name',
      name: 'adini_gir_kayit',
      desc: '',
      args: [],
    );
  }

  /// `Enter your surname`
  String get soyadini_gir_kayit {
    return Intl.message(
      'Enter your surname',
      name: 'soyadini_gir_kayit',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email address`
  String get mail_adresi_gir_kayit {
    return Intl.message(
      'Enter a valid email address',
      name: 'mail_adresi_gir_kayit',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid password`
  String get sifre_gir_kayit {
    return Intl.message(
      'Enter a valid password',
      name: 'sifre_gir_kayit',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter your password`
  String get sifrenitekrar_gir_kayit {
    return Intl.message(
      'Re-enter your password',
      name: 'sifrenitekrar_gir_kayit',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password Page`
  String get sife_unuttum_sayfasi {
    return Intl.message(
      'Forgot Password Page',
      name: 'sife_unuttum_sayfasi',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get mail_adresi_gir_sifreunuttum {
    return Intl.message(
      'Enter your email address',
      name: 'mail_adresi_gir_sifreunuttum',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new password`
  String get sifre_gir_sifreunuttum {
    return Intl.message(
      'Enter your new password',
      name: 'sifre_gir_sifreunuttum',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get sifre_degistir {
    return Intl.message(
      'Change Password',
      name: 'sifre_degistir',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get anasayfa {
    return Intl.message('Home', name: 'anasayfa', desc: '', args: []);
  }

  /// `Welcome`
  String get hosgeldiniz {
    return Intl.message('Welcome', name: 'hosgeldiniz', desc: '', args: []);
  }

  /// `Premium Offer`
  String get premium_firsati {
    return Intl.message(
      'Premium Offer',
      name: 'premium_firsati',
      desc: '',
      args: [],
    );
  }

  /// `✨ Upgrade to premium now, don’t miss the opportunities!`
  String get premium_firsati_1 {
    return Intl.message(
      '✨ Upgrade to premium now, don’t miss the opportunities!',
      name: 'premium_firsati_1',
      desc: '',
      args: [],
    );
  }

  /// `✨ Switch to Premium, Discover the Privileges Now!\n\n✔️ Unlimited Movie & TV Show Streaming\n✔️ Ad-Free Experience\n✔️ 4K Ultra HD & 3D Sound\n✔️ Watch Anywhere (Phone, Tablet, TV, PC)\n✔️ Exclusive Premium Discounts\n\n🔥 First Month Only: 19.90₺\n💳 Following Months: 59.90₺ / month\n\n👉 Join Premium Now, Don’t Miss Out!`
  String get premium_firsati_2 {
    return Intl.message(
      '✨ Switch to Premium, Discover the Privileges Now!\n\n✔️ Unlimited Movie & TV Show Streaming\n✔️ Ad-Free Experience\n✔️ 4K Ultra HD & 3D Sound\n✔️ Watch Anywhere (Phone, Tablet, TV, PC)\n✔️ Exclusive Premium Discounts\n\n🔥 First Month Only: 19.90₺\n💳 Following Months: 59.90₺ / month\n\n👉 Join Premium Now, Don’t Miss Out!',
      name: 'premium_firsati_2',
      desc: '',
      args: [],
    );
  }

  /// `Premium Purchase Page`
  String get premium_satin_alma_sayfasi {
    return Intl.message(
      'Premium Purchase Page',
      name: 'premium_satin_alma_sayfasi',
      desc: '',
      args: [],
    );
  }

  /// `🎬 Switch to Premium, Remove the Limits of Entertainment!\n                      \nSay goodbye to ads interrupting your movie and series fun, low quality visuals, and limited access. With Premium membership, open the doors of the entertainment world wide!\n                      \n🌟 Premium Membership Privileges\n                      \n✔️ Unlimited Movie & TV Show Streaming\nWatch thousands of movies, series, and documentaries as much as you want. Access new releases instantly!\n                      \n✔️ Ad-Free, Uninterrupted Experience\nSay goodbye to ads appearing at the most exciting moments! Enjoy a completely seamless experience.\n                      \n✔️ 4K Ultra HD + 3D Sound\nWatch your favorite scenes in cinema quality. With high resolution and powerful sound, feel like you are inside the movie.\n                      \n✔️ Freedom to Watch Anywhere\nWith a single membership, easily log in from your phone, tablet, computer, or smart TV. Wherever you are, entertainment is with you.\n                      \n✔️ Exclusive Premium Discounts\nSpecial campaigns, content, and advantages only for Premium users are waiting for you.\n                      \n💸 Pricing\n                      \n🔥 First Month: Only 19.90₺\n💳 Following Months: 59.90₺ / month\n                      \n👉 Step into the Premium world at a low cost, enjoy unlimited entertainment to the fullest!\n                      \n🎁 Why Switch to Premium?\n                      \nA better quality, faster, and freer viewing experience.\n                      \nThe chance to watch your favorite movies anytime, anywhere.\n                      \nA library full of ad-free, uninterrupted, and completely personalized content.\n                      \nBring the cinema experience to your home at affordable prices.\n                      \n🚀 Join Premium Now!\n                      \nDon’t limit your entertainment, feel the difference. Switch to Premium now and don’t miss the first month only 19.90₺ offer!\n                      \n👉 [Switch to Premium]`
  String get premium_icerik {
    return Intl.message(
      '🎬 Switch to Premium, Remove the Limits of Entertainment!\n                      \nSay goodbye to ads interrupting your movie and series fun, low quality visuals, and limited access. With Premium membership, open the doors of the entertainment world wide!\n                      \n🌟 Premium Membership Privileges\n                      \n✔️ Unlimited Movie & TV Show Streaming\nWatch thousands of movies, series, and documentaries as much as you want. Access new releases instantly!\n                      \n✔️ Ad-Free, Uninterrupted Experience\nSay goodbye to ads appearing at the most exciting moments! Enjoy a completely seamless experience.\n                      \n✔️ 4K Ultra HD + 3D Sound\nWatch your favorite scenes in cinema quality. With high resolution and powerful sound, feel like you are inside the movie.\n                      \n✔️ Freedom to Watch Anywhere\nWith a single membership, easily log in from your phone, tablet, computer, or smart TV. Wherever you are, entertainment is with you.\n                      \n✔️ Exclusive Premium Discounts\nSpecial campaigns, content, and advantages only for Premium users are waiting for you.\n                      \n💸 Pricing\n                      \n🔥 First Month: Only 19.90₺\n💳 Following Months: 59.90₺ / month\n                      \n👉 Step into the Premium world at a low cost, enjoy unlimited entertainment to the fullest!\n                      \n🎁 Why Switch to Premium?\n                      \nA better quality, faster, and freer viewing experience.\n                      \nThe chance to watch your favorite movies anytime, anywhere.\n                      \nA library full of ad-free, uninterrupted, and completely personalized content.\n                      \nBring the cinema experience to your home at affordable prices.\n                      \n🚀 Join Premium Now!\n                      \nDon’t limit your entertainment, feel the difference. Switch to Premium now and don’t miss the first month only 19.90₺ offer!\n                      \n👉 [Switch to Premium]',
      name: 'premium_icerik',
      desc: '',
      args: [],
    );
  }

  /// `Most Watched`
  String get encok_izlenen {
    return Intl.message(
      'Most Watched',
      name: 'encok_izlenen',
      desc: '',
      args: [],
    );
  }

  /// `🎬 Action`
  String get aksiyon {
    return Intl.message('🎬 Action', name: 'aksiyon', desc: '', args: []);
  }

  /// `🗺️ Adventure`
  String get macera {
    return Intl.message('🗺️ Adventure', name: 'macera', desc: '', args: []);
  }

  /// `🐭 Animation`
  String get animasyon {
    return Intl.message('🐭 Animation', name: 'animasyon', desc: '', args: []);
  }

  /// `😂 Comedy`
  String get komedi {
    return Intl.message('😂 Comedy', name: 'komedi', desc: '', args: []);
  }

  /// `🔫 Crime`
  String get suc {
    return Intl.message('🔫 Crime', name: 'suc', desc: '', args: []);
  }

  /// `😢 Drama`
  String get drama {
    return Intl.message('😢 Drama', name: 'drama', desc: '', args: []);
  }

  /// `👨‍👩‍👧‍👦 Family`
  String get aile {
    return Intl.message('👨‍👩‍👧‍👦 Family', name: 'aile', desc: '', args: []);
  }

  /// `🧙‍♂️ Fantasy`
  String get fantastik {
    return Intl.message('🧙‍♂️ Fantasy', name: 'fantastik', desc: '', args: []);
  }

  /// `🏰 History`
  String get tarih {
    return Intl.message('🏰 History', name: 'tarih', desc: '', args: []);
  }

  /// `👻 Horror`
  String get korku {
    return Intl.message('👻 Horror', name: 'korku', desc: '', args: []);
  }

  /// `🎵 Music`
  String get muzik {
    return Intl.message('🎵 Music', name: 'muzik', desc: '', args: []);
  }

  /// `🕵️ Mystery`
  String get gizem {
    return Intl.message('🕵️ Mystery', name: 'gizem', desc: '', args: []);
  }

  /// `❤️ Romance`
  String get romantik {
    return Intl.message('❤️ Romance', name: 'romantik', desc: '', args: []);
  }

  /// `👽 Sci-Fi`
  String get bilim_kurgu {
    return Intl.message('👽 Sci-Fi', name: 'bilim_kurgu', desc: '', args: []);
  }

  /// `⚡ Thriller`
  String get gerilim {
    return Intl.message('⚡ Thriller', name: 'gerilim', desc: '', args: []);
  }

  /// `🤠 Western`
  String get kovboy {
    return Intl.message('🤠 Western', name: 'kovboy', desc: '', args: []);
  }

  /// `Coming Soon`
  String get yayinlanmasi_beklenen {
    return Intl.message(
      'Coming Soon',
      name: 'yayinlanmasi_beklenen',
      desc: '',
      args: [],
    );
  }

  /// `The Conjuring 4`
  String get korku_seansi4 {
    return Intl.message(
      'The Conjuring 4',
      name: 'korku_seansi4',
      desc: '',
      args: [],
    );
  }

  /// `This upcoming supernatural horror movie follows paranormal investigators Ed and Lorraine Warren. They face their final and most terrifying case when confronting the demonic forces that cruelly haunt a family in Pennsylvania. The film is inspired by the real-life Smurl haunting case.`
  String get korku_seansi4_icerik {
    return Intl.message(
      'This upcoming supernatural horror movie follows paranormal investigators Ed and Lorraine Warren. They face their final and most terrifying case when confronting the demonic forces that cruelly haunt a family in Pennsylvania. The film is inspired by the real-life Smurl haunting case.',
      name: 'korku_seansi4_icerik',
      desc: '',
      args: [],
    );
  }

  /// `Movie not found`
  String get film_bulunamadi {
    return Intl.message(
      'Movie not found',
      name: 'film_bulunamadi',
      desc: '',
      args: [],
    );
  }

  /// `No movie title`
  String get film_adi_yok {
    return Intl.message(
      'No movie title',
      name: 'film_adi_yok',
      desc: '',
      args: [],
    );
  }

  /// `Saved Movies`
  String get kayitli_filmler {
    return Intl.message(
      'Saved Movies',
      name: 'kayitli_filmler',
      desc: '',
      args: [],
    );
  }

  /// `Saved`
  String get kayitlilar {
    return Intl.message('Saved', name: 'kayitlilar', desc: '', args: []);
  }

  /// `Movie Search`
  String get film_arama {
    return Intl.message('Movie Search', name: 'film_arama', desc: '', args: []);
  }

  /// `New`
  String get yeni {
    return Intl.message('New', name: 'yeni', desc: '', args: []);
  }

  /// `Search`
  String get arama {
    return Intl.message('Search', name: 'arama', desc: '', args: []);
  }

  /// `Additional Actions`
  String get ek_islemler {
    return Intl.message(
      'Additional Actions',
      name: 'ek_islemler',
      desc: '',
      args: [],
    );
  }

  /// `QR Code`
  String get karekod {
    return Intl.message('QR Code', name: 'karekod', desc: '', args: []);
  }

  /// `App QR Code`
  String get uygulama_karekodu {
    return Intl.message(
      'App QR Code',
      name: 'uygulama_karekodu',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get geribildirim {
    return Intl.message('Feedback', name: 'geribildirim', desc: '', args: []);
  }

  /// `Information`
  String get bilgilendirme {
    return Intl.message(
      'Information',
      name: 'bilgilendirme',
      desc: '',
      args: [],
    );
  }

  /// `Information Text`
  String get bilgilendirme_yazisi {
    return Intl.message(
      'Information Text',
      name: 'bilgilendirme_yazisi',
      desc: '',
      args: [],
    );
  }

  /// `Step into the magical world of cinema! ✨\n\n\nWith the Movie app, discover your favorite movies, watch trailers, and easily access detailed information. 🎥\n\nThanks to the wide movie archive categorized by genres, finding the right content for your taste is super easy. 🍿\n\nAdd to favorites, be the first to know about new releases, and share with your friends. 🌟\n\nWith its modern design and user-friendly interface, carry the joy of movies with you at all times. 📱\n\nMovie is an indispensable guide for cinema lovers! 🚀`
  String get bilgilendirme_yazisi_icerik {
    return Intl.message(
      'Step into the magical world of cinema! ✨\n\n\nWith the Movie app, discover your favorite movies, watch trailers, and easily access detailed information. 🎥\n\nThanks to the wide movie archive categorized by genres, finding the right content for your taste is super easy. 🍿\n\nAdd to favorites, be the first to know about new releases, and share with your friends. 🌟\n\nWith its modern design and user-friendly interface, carry the joy of movies with you at all times. 📱\n\nMovie is an indispensable guide for cinema lovers! 🚀',
      name: 'bilgilendirme_yazisi_icerik',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get anladim {
    return Intl.message('Got it', name: 'anladim', desc: '', args: []);
  }

  /// `Logout`
  String get cikis {
    return Intl.message('Logout', name: 'cikis', desc: '', args: []);
  }

  /// `Logout Screen`
  String get cikis_ekrani {
    return Intl.message(
      'Logout Screen',
      name: 'cikis_ekrani',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get cikis_ekrani_icerik {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'cikis_ekrani_icerik',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get iptal {
    return Intl.message('Cancel', name: 'iptal', desc: '', args: []);
  }

  /// `Confirm`
  String get onayla {
    return Intl.message('Confirm', name: 'onayla', desc: '', args: []);
  }

  /// `Average movie rating`
  String get film_puan_ortalamasi {
    return Intl.message(
      'Average movie rating',
      name: 'film_puan_ortalamasi',
      desc: '',
      args: [],
    );
  }

  /// `Number of users rated`
  String get puanlama_yapan_kisi_sayisi {
    return Intl.message(
      'Number of users rated',
      name: 'puanlama_yapan_kisi_sayisi',
      desc: '',
      args: [],
    );
  }

  /// `Release date`
  String get yayinlanis_tarihi {
    return Intl.message(
      'Release date',
      name: 'yayinlanis_tarihi',
      desc: '',
      args: [],
    );
  }

  /// `Popularity`
  String get populerligi {
    return Intl.message('Popularity', name: 'populerligi', desc: '', args: []);
  }

  /// `See details on the website -->`
  String get web_sayfasina_bakin {
    return Intl.message(
      'See details on the website -->',
      name: 'web_sayfasina_bakin',
      desc: '',
      args: [],
    );
  }

  /// `Ad not found`
  String get reklam_bulunamadi {
    return Intl.message(
      'Ad not found',
      name: 'reklam_bulunamadi',
      desc: '',
      args: [],
    );
  }

  /// `System language has been changed to Turkish`
  String get sistem_dili_degisti {
    return Intl.message(
      'System language has been changed to Turkish',
      name: 'sistem_dili_degisti',
      desc: '',
      args: [],
    );
  }

  /// `Movie successfully added to saved!`
  String get film_basarili_bir_sekilde_kayitlara_eklendi {
    return Intl.message(
      'Movie successfully added to saved!',
      name: 'film_basarili_bir_sekilde_kayitlara_eklendi',
      desc: '',
      args: [],
    );
  }

  /// `Movie successfully removed from saved!`
  String get film_basarili_bir_sekilde_kayitlardan_cikarildi {
    return Intl.message(
      'Movie successfully removed from saved!',
      name: 'film_basarili_bir_sekilde_kayitlardan_cikarildi',
      desc: '',
      args: [],
    );
  }

  /// `Registration completed successfully!`
  String get kayit_basarili_bir_sekilde_yapildi {
    return Intl.message(
      'Registration completed successfully!',
      name: 'kayit_basarili_bir_sekilde_yapildi',
      desc: '',
      args: [],
    );
  }

  /// `Password updated!`
  String get sifre_guncellendi {
    return Intl.message(
      'Password updated!',
      name: 'sifre_guncellendi',
      desc: '',
      args: [],
    );
  }

  /// `Movie successfully added to saved!`
  String get detaysayfasi_snackbar_mesaj1 {
    return Intl.message(
      'Movie successfully added to saved!',
      name: 'detaysayfasi_snackbar_mesaj1',
      desc: '',
      args: [],
    );
  }

  /// `Movie successfully removed from saved!`
  String get detaysayfasi_snackbar_mesaj2 {
    return Intl.message(
      'Movie successfully removed from saved!',
      name: 'detaysayfasi_snackbar_mesaj2',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch data from the system!`
  String get maingiris_snackbar_vericekilemedi {
    return Intl.message(
      'Failed to fetch data from the system!',
      name: 'maingiris_snackbar_vericekilemedi',
      desc: '',
      args: [],
    );
  }

  /// `Empty fields exist, please try again!`
  String get maingiris_snackbar_bosalanvar {
    return Intl.message(
      'Empty fields exist, please try again!',
      name: 'maingiris_snackbar_bosalanvar',
      desc: '',
      args: [],
    );
  }

  /// `Email or password is incorrect!`
  String get maingiris_snackbar_mailveyasifreyanlis {
    return Intl.message(
      'Email or password is incorrect!',
      name: 'maingiris_snackbar_mailveyasifreyanlis',
      desc: '',
      args: [],
    );
  }

  /// `Empty fields exist, please try again!`
  String get mainkayit_snackbar_bosalanlarvar {
    return Intl.message(
      'Empty fields exist, please try again!',
      name: 'mainkayit_snackbar_bosalanlarvar',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match!`
  String get mainkayit_snackbar_sifreuyusmuyor {
    return Intl.message(
      'Passwords do not match!',
      name: 'mainkayit_snackbar_sifreuyusmuyor',
      desc: '',
      args: [],
    );
  }

  /// `Registration completed successfully!`
  String get mainkayit_snackbar_kayitbasarili {
    return Intl.message(
      'Registration completed successfully!',
      name: 'mainkayit_snackbar_kayitbasarili',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address!`
  String get mainkayit_snackbar_gecerlimailgir {
    return Intl.message(
      'Please enter a valid email address!',
      name: 'mainkayit_snackbar_gecerlimailgir',
      desc: '',
      args: [],
    );
  }

  /// `Empty fields exist!`
  String get mainsifremiunuttum_snackbar_bosalanvar {
    return Intl.message(
      'Empty fields exist!',
      name: 'mainsifremiunuttum_snackbar_bosalanvar',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch data from the system!`
  String get mainsifremiunuttum_snackbar_verilercekilemedi {
    return Intl.message(
      'Failed to fetch data from the system!',
      name: 'mainsifremiunuttum_snackbar_verilercekilemedi',
      desc: '',
      args: [],
    );
  }

  /// `Password updated!`
  String get mainsifremiunuttum_snackbar_sifreguncellendi {
    return Intl.message(
      'Password updated!',
      name: 'mainsifremiunuttum_snackbar_sifreguncellendi',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations, you have purchased Premium`
  String get anasayfapremium_snackbar_premiumaldin {
    return Intl.message(
      'Congratulations, you have purchased Premium',
      name: 'anasayfapremium_snackbar_premiumaldin',
      desc: '',
      args: [],
    );
  }

  /// `Subject`
  String get mailkonu {
    return Intl.message('Subject', name: 'mailkonu', desc: '', args: []);
  }

  /// `You can write your thoughts here`
  String get maildusunce {
    return Intl.message(
      'You can write your thoughts here',
      name: 'maildusunce',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'tr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
