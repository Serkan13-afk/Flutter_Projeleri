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
  String get girisyap {
    return Intl.message('Login', name: 'girisyap', desc: '', args: []);
  }

  /// `Sign up`
  String get kayityap {
    return Intl.message('Sign up', name: 'kayityap', desc: '', args: []);
  }

  /// `Enter your email address`
  String get gecerlimailgir_giris {
    return Intl.message(
      'Enter your email address',
      name: 'gecerlimailgir_giris',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get gecerlisifregir_giris {
    return Intl.message(
      'Enter your password',
      name: 'gecerlisifregir_giris',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get isminizi_girin {
    return Intl.message(
      'Enter your name',
      name: 'isminizi_girin',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email address`
  String get gecerlimailgir_kayit {
    return Intl.message(
      'Enter a valid email address',
      name: 'gecerlimailgir_kayit',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid password`
  String get gecerlisifregir_kayit {
    return Intl.message(
      'Enter a valid password',
      name: 'gecerlisifregir_kayit',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations, registration completed successfully`
  String get kayitislemi_basarili {
    return Intl.message(
      'Congratulations, registration completed successfully',
      name: 'kayitislemi_basarili',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed!`
  String get kayitislemi_basarisiz {
    return Intl.message(
      'Registration failed!',
      name: 'kayitislemi_basarisiz',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during registration:`
  String get kayitislemi_hataolustu {
    return Intl.message(
      'An error occurred during registration:',
      name: 'kayitislemi_hataolustu',
      desc: '',
      args: [],
    );
  }

  /// `Login successful!`
  String get girisislemi_basarili {
    return Intl.message(
      'Login successful!',
      name: 'girisislemi_basarili',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during login:`
  String get girisislemi_hataolustu {
    return Intl.message(
      'An error occurred during login:',
      name: 'girisislemi_hataolustu',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get mail_konu {
    return Intl.message('Feedback', name: 'mail_konu', desc: '', args: []);
  }

  /// `Your thoughts`
  String get mail_dusunce {
    return Intl.message(
      'Your thoughts',
      name: 'mail_dusunce',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get cevrimici {
    return Intl.message('Online', name: 'cevrimici', desc: '', args: []);
  }

  /// `Offline`
  String get cevrimdisi {
    return Intl.message('Offline', name: 'cevrimdisi', desc: '', args: []);
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

  /// `📱 The Profile Page is where users can best express themselves.\n\n👤 Here, profile picture and personal details can be easily viewed.\n\n⚙️ Users can adjust settings such as theme, language, and notifications.\n\n🔒 For security, there are options for password change and account management.\n\n💬 A custom status message and about section are added to the app.\n\n📂 Also, quick access to saved media and favorite chats is provided.\n\n🚪 Finally, the logout option supports account security.`
  String get bilgilendirme_icerik {
    return Intl.message(
      '📱 The Profile Page is where users can best express themselves.\n\n👤 Here, profile picture and personal details can be easily viewed.\n\n⚙️ Users can adjust settings such as theme, language, and notifications.\n\n🔒 For security, there are options for password change and account management.\n\n💬 A custom status message and about section are added to the app.\n\n📂 Also, quick access to saved media and favorite chats is provided.\n\n🚪 Finally, the logout option supports account security.',
      name: 'bilgilendirme_icerik',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get anladim {
    return Intl.message('Got it', name: 'anladim', desc: '', args: []);
  }

  /// `Settings`
  String get ayarlar {
    return Intl.message('Settings', name: 'ayarlar', desc: '', args: []);
  }

  /// `QR Code`
  String get karekod {
    return Intl.message('QR Code', name: 'karekod', desc: '', args: []);
  }

  /// `Feedback`
  String get geribildirim {
    return Intl.message('Feedback', name: 'geribildirim', desc: '', args: []);
  }

  /// `Quick Message`
  String get hizlimesaj {
    return Intl.message(
      'Quick Message',
      name: 'hizlimesaj',
      desc: '',
      args: [],
    );
  }

  /// `Search person...`
  String get kisiara {
    return Intl.message(
      'Search person...',
      name: 'kisiara',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get anasayfa {
    return Intl.message('Home', name: 'anasayfa', desc: '', args: []);
  }

  /// `Profile`
  String get profil {
    return Intl.message('Profile', name: 'profil', desc: '', args: []);
  }

  /// `My Groups`
  String get gruplarim {
    return Intl.message('My Groups', name: 'gruplarim', desc: '', args: []);
  }

  /// `You are not a member of any group, try creating a new one 😄`
  String get hicbirgruba_uyedegilsin {
    return Intl.message(
      'You are not a member of any group, try creating a new one 😄',
      name: 'hicbirgruba_uyedegilsin',
      desc: '',
      args: [],
    );
  }

  /// `You cannot remove the admin from the group`
  String get yoneticiyigrptan_silemezsin {
    return Intl.message(
      'You cannot remove the admin from the group',
      name: 'yoneticiyigrptan_silemezsin',
      desc: '',
      args: [],
    );
  }

  /// `Add Group`
  String get grup_ekle {
    return Intl.message('Add Group', name: 'grup_ekle', desc: '', args: []);
  }

  /// `Create Group`
  String get grup_olustur {
    return Intl.message(
      'Create Group',
      name: 'grup_olustur',
      desc: '',
      args: [],
    );
  }

  /// `Group name...`
  String get grup_adi {
    return Intl.message('Group name...', name: 'grup_adi', desc: '', args: []);
  }

  /// `Group created successfully`
  String get grup_basarilisekilde_olusturuldu {
    return Intl.message(
      'Group created successfully',
      name: 'grup_basarilisekilde_olusturuldu',
      desc: '',
      args: [],
    );
  }

  /// `Group name field cannot be left empty!`
  String get grupadi_alani {
    return Intl.message(
      'Group name field cannot be left empty!',
      name: 'grupadi_alani',
      desc: '',
      args: [],
    );
  }

  /// `Group not found!`
  String get grupBulanamadi {
    return Intl.message(
      'Group not found!',
      name: 'grupBulanamadi',
      desc: '',
      args: [],
    );
  }

  /// `Group`
  String get grup {
    return Intl.message('Group', name: 'grup', desc: '', args: []);
  }

  /// `No messages yet`
  String get henuzmesaj_yok {
    return Intl.message(
      'No messages yet',
      name: 'henuzmesaj_yok',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get bilinmeyen {
    return Intl.message('Unknown', name: 'bilinmeyen', desc: '', args: []);
  }

  /// `Write a message...`
  String get mesaz_yaz {
    return Intl.message(
      'Write a message...',
      name: 'mesaz_yaz',
      desc: '',
      args: [],
    );
  }

  /// `Remove person from group`
  String get kisiyi_gruptancikar {
    return Intl.message(
      'Remove person from group',
      name: 'kisiyi_gruptancikar',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to remove this person from the group?`
  String get kisiyi_gruptancikarmakistiyormusun {
    return Intl.message(
      'Do you want to remove this person from the group?',
      name: 'kisiyi_gruptancikarmakistiyormusun',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get iptal {
    return Intl.message('Cancel', name: 'iptal', desc: '', args: []);
  }

  /// `You removed the person`
  String get kisiyi_gruptancikartiniz {
    return Intl.message(
      'You removed the person',
      name: 'kisiyi_gruptancikartiniz',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get onayla {
    return Intl.message('Confirm', name: 'onayla', desc: '', args: []);
  }

  /// `Only the admin can remove members`
  String get yoneticidisinda_kimsecikaramaz {
    return Intl.message(
      'Only the admin can remove members',
      name: 'yoneticidisinda_kimsecikaramaz',
      desc: '',
      args: [],
    );
  }

  /// `You left the group`
  String get gruptan_ayrildiniz {
    return Intl.message(
      'You left the group',
      name: 'gruptan_ayrildiniz',
      desc: '',
      args: [],
    );
  }

  /// `Member`
  String get uye {
    return Intl.message('Member', name: 'uye', desc: '', args: []);
  }

  /// `There are empty fields!`
  String get uyeekle {
    return Intl.message(
      'There are empty fields!',
      name: 'uyeekle',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get yonetici {
    return Intl.message('Admin', name: 'yonetici', desc: '', args: []);
  }

  /// `User`
  String get kulanici {
    return Intl.message('User', name: 'kulanici', desc: '', args: []);
  }

  /// `Leave group`
  String get gruptan_cik {
    return Intl.message('Leave group', name: 'gruptan_cik', desc: '', args: []);
  }

  /// `There are empty fields!`
  String get kisieklendi {
    return Intl.message(
      'There are empty fields!',
      name: 'kisieklendi',
      desc: '',
      args: [],
    );
  }

  /// `The person you clicked is already in the group, try another search!`
  String get tikladiginkisi_grupta {
    return Intl.message(
      'The person you clicked is already in the group, try another search!',
      name: 'tikladiginkisi_grupta',
      desc: '',
      args: [],
    );
  }

  /// `Add member to your group`
  String get grubuna_kisiekle {
    return Intl.message(
      'Add member to your group',
      name: 'grubuna_kisiekle',
      desc: '',
      args: [],
    );
  }

  /// `Add person...`
  String get kisi_ekle {
    return Intl.message('Add person...', name: 'kisi_ekle', desc: '', args: []);
  }

  /// `Profile Page`
  String get profilsayfasi {
    return Intl.message(
      'Profile Page',
      name: 'profilsayfasi',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get hosgeldin {
    return Intl.message('Welcome', name: 'hosgeldin', desc: '', args: []);
  }

  /// `Logout`
  String get cikis {
    return Intl.message('Logout', name: 'cikis', desc: '', args: []);
  }

  /// `Are you sure you want to log out?`
  String get cikisyapmak_istedigineeminmisin {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'cikisyapmak_istedigineeminmisin',
      desc: '',
      args: [],
    );
  }

  /// `There are empty fields!`
  String get bosalanlar_var {
    return Intl.message(
      'There are empty fields!',
      name: 'bosalanlar_var',
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
