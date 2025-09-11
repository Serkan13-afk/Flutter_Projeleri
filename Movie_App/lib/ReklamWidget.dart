import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:movieapp/generated/l10n.dart';

class Reklamwidget extends StatefulWidget {
  const Reklamwidget({super.key});

  @override
  State<Reklamwidget> createState() => _ReklamwidgetState();
}

class _ReklamwidgetState extends State<Reklamwidget> {
  late BannerAd bannerAd;
  bool yuklendiMi = false;

  @override
  void initState() {
    super.initState();
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // TEST ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => yuklendiMi = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Reklam yüklenemedi: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return yuklendiMi
        ? SizedBox(
          width: bannerAd.size.width.toDouble(),
          height: bannerAd.size.height.toDouble(),
          child: AdWidget(ad: bannerAd),
        )
        : SizedBox(
          width: 100,
          height: 500,
          child: Text(S.of(context).reklam_bulunamadi),
        );
  }
}
