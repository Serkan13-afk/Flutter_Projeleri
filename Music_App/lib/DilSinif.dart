import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DilSinif {
  static Locale? varsayilan;

  static Future<void> dilKayit(String diltur) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString("dil_kod", diltur);

    varsayilan = await Locale(diltur);
  }

  static Future<void> dilGetir() async {
    final pref = await SharedPreferences.getInstance();

    final yukludil = await pref.getString("dil_kod") ?? "tr";

    varsayilan = Locale(yukludil);
  }
}
