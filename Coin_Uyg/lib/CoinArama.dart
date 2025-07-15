import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Coin.dart';

class Coinarama extends StatefulWidget {
  const Coinarama({super.key});

  @override
  State<Coinarama> createState() => _CoinaramaState();
}

class _CoinaramaState extends State<Coinarama> {
  List<Coin> coinListe = [];

  Future<void> coinCekme() async {
    var url = Uri.parse(
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        coinListe = data.map((json) => Coin.fromJson(json)).toList();
      });
    } else {
      print("Veri çekilemedi. Durum kodu: ${response.statusCode}");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coinCekme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coinarama')),
      body:
          coinListe.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: coinListe.length,
                itemBuilder: (context, index) {
                  final coin = coinListe[index];
                  return ListTile(
                    leading: Image.network(coin.gorsel, width: 40),
                    title: Text(coin.isim),
                    subtitle: Text("\$${coin.fiyat.toStringAsFixed(2)}"),
                  );
                },
              ),
    );
  }
}
