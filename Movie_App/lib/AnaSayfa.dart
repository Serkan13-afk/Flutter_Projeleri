import 'dart:collection';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/DetaySayfa.dart';
import 'package:movieapp/KayitSepetState.dart';
import 'package:movieapp/KayitliCubit.dart';
import 'package:movieapp/Kisiler.dart';
import 'package:movieapp/Movie.dart';
import 'package:movieapp/Providerler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart' as badges;
import 'package:url_launcher/url_launcher.dart';
import 'package:movieapp/generated/l10n.dart';

class Anasayfa extends StatefulWidget {
  late Kisiler kisiler;

  Anasayfa(this.kisiler);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animationDegerler;
  late TabController tabController;
  bool premiumCardinaBasildimi = true;
  bool encoksevilenucluyuklendimi = false;
  List<Movie> encokpopullerolan3 = [];
  List<Movie> allmovie = [];
  Map<int, bool> seciliFilmler = {};
  String kareKod = "https://drive.google.com/file/d/1y6eErZWAh6686T29TR_lSw0-QDDkMUNm/view?usp=sharing";
  var refKisiler = FirebaseDatabase.instance.ref().child("kisiler_tablo");
  bool premiumVarmi = false;

  Future<void> mailControl() async {
    final mailIcerik = Uri(
      scheme: "mailto",
      path: "infoapp686@gmail.com", //mail adresi
      queryParameters: {
        'subject': S.of(context).mailkonu,
        'body': S.of(context).maildusunce,
      },
    );
    if (await canLaunchUrl(mailIcerik)) {
      // yukarıdaki nesneye bakıyor sorun varmı yoksa gir
      await launchUrl(
        mailIcerik,
        mode: LaunchMode.externalApplication,
      ); // sonrada bilgileri al gönder
    } else {
      print("Mail gönderilemiyor");
    }
  }

  Widget premiumCard() {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return widget.kisiler.kisipremiumVarMi!
            ? Center()
            : GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: AlertDialog(
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.lightBlue,
                            width: 3.0,
                          ),
                        ),
                        title: Align(
                          alignment: Alignment.center,
                          child: Text(S.of(context).premium_satin_alma_sayfasi),
                        ),
                        content: Text(
                          S.of(context).premium_icerik,
                          style: TextStyle(fontSize: 12),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              S.of(context).iptal,
                              style: TextStyle(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              side: BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              premiumOlma();
                              Navigator.pop(context);
                            },
                            child: Text(
                              S.of(context).onayla,
                              style: TextStyle(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              side: BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Card(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.tealAccent, width: 2.0),
                ),
                elevation: 15,
                shadowColor: temaNesne.temaOku() ? Colors.white : Colors.black,
                color: Colors.deepPurple[800],
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          premiumCardinaBasildimi
                              ? S.of(context).premium_firsati_1
                              : S.of(context).premium_firsati_2,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color:
                                temaNesne.temaOku()
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            premiumCardinaBasildimi = !premiumCardinaBasildimi;
                          });
                        },
                        icon: Icon(
                          premiumCardinaBasildimi
                              ? Icons.expand_more
                              : Icons.expand_less,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
      },
    );
  }

  Widget encokIzlenen3() {
    allmovie.sort((a, b) => b.voteAverage!.compareTo(a.voteAverage!));

    encokpopullerolan3 = allmovie.take(3).toList();

    // veri yüklenmediyse shimmer efekt gösterelim
    if (encoksevilenucluyuklendimi) {
      return SizedBox(
        height: 190,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(8),
          itemCount: 3, // shimmer için placeholder
          itemBuilder: (context, index) {
            return Card(
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.teal, width: 2.0),
              ),
              elevation: 8,
              child: Container(
                width: 150,
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[400]!,
                        highlightColor: Colors.white,
                        child: Icon(Icons.save),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.white,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.white,
                      child: Container(
                        width: 80,
                        height: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    // veri geldiyse normal listeyi render et
    return SizedBox(
      height: 240, // sabit yükseklik
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(4),
        itemCount: encokpopullerolan3.length,
        itemBuilder: (context, index) {
          var veri = encokpopullerolan3[index];
          return Consumer<TemaOkuma>(
            builder: (context, temaNesne, child) {
              bool dark = temaNesne.temaOku();
              return BlocBuilder<KayitliCubit, KayitSepetState>(
                builder: (context, state) {
                  return Card(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.tealAccent,
                        width: 2.0,
                      ),
                    ),
                    elevation: 8,
                    color: dark ? Color(0xFF1E293B) : Colors.grey[200],
                    shadowColor: dark ? Colors.white : Colors.black,
                    child: Container(
                      width: 150, // sabit genişlik
                      height: 210, // sabit yükseklik
                      padding: EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  seciliFilmler[index] =
                                      !(seciliFilmler[index] ?? false);
                                });
                                seciliFilmler[index]!
                                    ? context.read<KayitliCubit>().veriEkle(
                                      veri,
                                    )
                                    : context.read<KayitliCubit>().veriSil(
                                      veri,
                                    );
                              },
                              icon:
                                  (seciliFilmler[index] ?? false)
                                      ? Icon(
                                        Icons.save_outlined,
                                        color: Colors.green[500],
                                      )
                                      : Icon(
                                        Icons.save_outlined,
                                        color: Colors.red[500],
                                      ),
                              iconSize: 20,
                            ),
                          ),
                          veri.posterPath != null
                              ? SizedBox(
                                width: 100,
                                height: 120,
                                child: Image.network(
                                  "https://image.tmdb.org/t/p/w200${veri.posterPath}",
                                  fit: BoxFit.cover,
                                ),
                              )
                              : Icon(Icons.movie, size: 100),
                          SizedBox(height: 8),
                          Text(
                            veri.title ?? "",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: dark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
    ;
  }

  Future<void> tumFilmler() async {
    var url = Uri.parse(
      "https://api.themoviedb.org/3/movie/popular?api_key=c2fd7f416e2b96abc7cda7688e2ec59e&language=en-US&page=1",
    );
    var cevap = await http.get(url);
    if (cevap.statusCode == 200) {
      final veri = json.decode(cevap.body);

      final List<dynamic> movieList = veri["results"];
      if (movieList.isNotEmpty) {
        setState(() {
          allmovie.clear(); // önce listeyi temizle
          for (var veri in movieList) {
            var filmler = Movie.fromJson(veri);
            allmovie.add(filmler);
          }
          encoksevilenucluyuklendimi = false; // shimmer'ı kapat
        });
      }
    } else {
      print("Veri çekilemedi. Durum kodu: ${cevap.statusCode}");
    }
  }

  Widget yainlanmasiBeklenen() {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Scaffold()),
            );
          },
          child: Card(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.tealAccent, width: 2.0),
            ),
            shadowColor: temaNesne.temaOku() ? Colors.white : Colors.black,
            elevation: 10,
            color: Colors.pink[500],
            child: ListTile(
              leading: Image.asset(
                "resimler/korkuSeansi.jpg",
                fit: BoxFit.cover,
              ),
              title: Text(S.of(context).korku_seansi4),
              subtitle: Text(
                "This upcoming supernatural horror film follows paranormal investigators Ed and Lorraine Warren as they face their final and most terrifying case—confronting demonic forces that relentlessly torment a family in Pennsylvania, inspired by the real-life Smurl haunting.",
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> premiumOlma() async {
    var event = await refKisiler.once();
    var gelenDegerler = event.snapshot.value as dynamic;
    if (gelenDegerler == null) {
      print("Veriler alınamadı");
      return;
    }
    String? key1;
    Kisiler? arananKisi;

    gelenDegerler.forEach((key, nesne) {
      var gelenKisi = Kisiler.fromJson(nesne);
      if (widget.kisiler.kisiMail == gelenKisi.kisiMail) {
        arananKisi = gelenKisi;
        key1 = key;
      }
    });
    if (key1 != null && arananKisi != null) {
      var guncelBilgi = HashMap<String, dynamic>();
      guncelBilgi["kisiAd"] = arananKisi!.kisiAd;
      guncelBilgi["kisiMail"] = arananKisi!.kisiMail;
      guncelBilgi["kisiSifre"] = arananKisi!.kisiSifre;
      guncelBilgi["kisiSoyad"] = arananKisi!.kisiSoyad;
      guncelBilgi["kisiStory"] = arananKisi!.kisiStory;
      guncelBilgi["kisiprofilUrl"] = arananKisi!.kisiprofilUrl;
      guncelBilgi["kisipremiumVarMi"] = true;

      await refKisiler.child(key1!).update(guncelBilgi);
      setState(() {
        premiumVarmi = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).anasayfapremium_snackbar_premiumaldin),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    premiumVarmi = widget.kisiler.kisipremiumVarMi!;
    tumFilmler();
    tabController = TabController(length: 16, vsync: this);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    animationDegerler = Tween(begin: -100.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    )..addListener(() {
      setState(() {});
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120), // yükseklik verdik
        child: Consumer<TemaOkuma>(
          builder: (context, temaNesne, child) {
            return AppBar(
              title: Text(
                S.of(context).anasayfa,
                style: TextStyle(
                  color: temaNesne.temaOku() ? Colors.black : Colors.white,
                ),
              ),
              // burayı ekle
              backgroundColor:
                  temaNesne.temaOku() ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              shadowColor: temaNesne.temaOku() ? Colors.black : Colors.white,
              elevation: 10,
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10, top: 10),
                  child: ClipOval(
                    child: Image.network("${widget.kisiler.kisiprofilUrl}"),
                  ),
                ),
              ],
            );
          },
        ),
      ),

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: Consumer<TemaOkuma>(
        builder: (context, temaNesne, child) {
          return Drawer(
            backgroundColor: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.purpleAccent[700]),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      S.of(context).ek_islemler,
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => Scaffold(
                              appBar: PreferredSize(
                                preferredSize: Size.fromHeight(100),
                                child: AppBar(
                                  backgroundColor:
                                      temaNesne.temaOku()
                                          ? Colors.white
                                          : Colors.black,
                                  shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  title: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      S.of(context).uygulama_karekodu,
                                      style: TextStyle(
                                        color:
                                            temaNesne.temaOku()
                                                ? Colors.black
                                                : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,

                              body: Center(
                                child: QrImageView(
                                  data: kareKod,
                                  version: QrVersions.auto,
                                  gapless: true,
                                  size: 300,

                                  foregroundColor:
                                      temaNesne.temaOku()
                                          ? Colors.white
                                          : Colors.black,
                                ),
                              ),
                            ),
                      ),
                    );
                  },
                  trailing: Icon(Icons.qr_code, color: Colors.black),
                  title: Text(
                    S.of(context).karekod,
                    style: TextStyle(color: Colors.black),
                  ),
                ),

                ListTile(
                  onTap: () {
                    mailControl();
                  },
                  trailing: Icon(
                    Icons.history_toggle_off_outlined,
                    color: Colors.black,
                  ),
                  title: Text(
                    S.of(context).geribildirim,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlue,
                              width: 3.0,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Text(S.of(context).bilgilendirme_yazisi),
                          content: Text(
                            S.of(context).bilgilendirme_yazisi_icerik,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(S.of(context).anladim),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  trailing: Icon(
                    Icons.info_outline_rounded,
                    color: Colors.black,
                  ),
                  title: Text(
                    S.of(context).bilgilendirme,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.lightBlue,
                              width: 3.0,
                            ),
                          ),
                          title: Text(S.of(context).cikis_ekrani),
                          content: Text(S.of(context).cikis_ekrani_icerik),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(S.of(context).iptal),
                            ),
                            TextButton(
                              onPressed: () {
                                SystemNavigator.pop();
                              },
                              child: Text(S.of(context).onayla),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  trailing: Icon(Icons.exit_to_app_rounded, color: Colors.red),
                  title: Text(
                    S.of(context).cikis,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      body: Transform.translate(
        offset: Offset(0.0, animationDegerler.value),
        child: SingleChildScrollView(
          child: Consumer<TemaOkuma>(
            builder: (context, temaNesne, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        left: 8,
                        bottom: 4,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          S.of(context).hosgeldiniz,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "--> ${widget.kisiler.kisiAd} ${widget.kisiler.kisiSoyad}",
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    premiumVarmi
                        ? SizedBox()
                        : Align(
                          alignment: Alignment.centerLeft,
                          child: Shimmer.fromColors(
                            baseColor:
                                temaNesne.temaOku()
                                    ? Colors.white60
                                    : Colors.black54,
                            highlightColor:
                                temaNesne.temaOku()
                                    ? Colors.white
                                    : Colors.black,
                            child: Text(
                              S.of(context).premium_firsati,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                    SizedBox(height: 10),
                    premiumVarmi ? SizedBox() : premiumCard(),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Shimmer.fromColors(
                        baseColor:
                            temaNesne.temaOku()
                                ? Colors.white60
                                : Colors.black54,
                        highlightColor:
                            temaNesne.temaOku() ? Colors.white : Colors.black,
                        child: Text(
                          S.of(context).encok_izlenen,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    encokIzlenen3(),
                    TabBar(
                      padding: EdgeInsets.only(right: 30, left: 10, top: 30),
                      controller: tabController,
                      labelColor: Colors.teal,
                      unselectedLabelColor: Colors.white54,
                      isScrollable: true,
                      indicatorColor: Colors.greenAccent,
                      tabs: [
                        Tab(text: S.of(context).aksiyon), // 28
                        Tab(text: S.of(context).macera), // 12
                        Tab(text: S.of(context).animasyon), // 16
                        Tab(text: S.of(context).komedi), // 35
                        Tab(text: S.of(context).suc), // 80
                        Tab(text: S.of(context).drama), // 18
                        Tab(text: S.of(context).aile), // 10751
                        Tab(text: S.of(context).fantastik), // 14
                        Tab(text: S.of(context).tarih), // 36
                        Tab(text: S.of(context).korku), // 27
                        Tab(text: S.of(context).muzik), // 10402
                        Tab(text: S.of(context).gizem), // 9648
                        Tab(text: S.of(context).romantik), // 10749
                        Tab(text: S.of(context).bilim_kurgu), // 878
                        Tab(text: S.of(context).gerilim), // 53
                        Tab(text: S.of(context).kovboy), // 37
                      ],
                    ),
                    SizedBox(
                      height: 250,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          Kategoriler(allmovie, 28),
                          Kategoriler(allmovie, 12),
                          Kategoriler(allmovie, 16),
                          Kategoriler(allmovie, 35),
                          Kategoriler(allmovie, 80),
                          Kategoriler(allmovie, 18),
                          Kategoriler(allmovie, 10751),
                          Kategoriler(allmovie, 14),
                          Kategoriler(allmovie, 36),
                          Kategoriler(allmovie, 27),
                          Kategoriler(allmovie, 10402),
                          Kategoriler(allmovie, 9648),
                          Kategoriler(allmovie, 10749),
                          Kategoriler(allmovie, 878),
                          Kategoriler(allmovie, 53),
                          Kategoriler(allmovie, 37),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Shimmer.fromColors(
                        baseColor:
                            temaNesne.temaOku()
                                ? Colors.white60
                                : Colors.black54,
                        highlightColor:
                            temaNesne.temaOku() ? Colors.white : Colors.black,
                        child: Text(
                          S.of(context).yayinlanmasi_beklenen,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),

                    yainlanmasiBeklenen(),
                    SizedBox(height: 30),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Kategoriler extends StatelessWidget {
  final List<Movie> movies;
  final int genreId;

  Kategoriler(this.movies, this.genreId);

  @override
  Widget build(BuildContext context) {
    List<Movie> turDizi = [];
    for (var filtre in movies) {
      if (filtre.genreIds!.contains(genreId)) {
        turDizi.add(filtre);
      }
    }
    if (turDizi.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(S.of(context).film_bulunamadi)],
        ),
      );
    }
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: turDizi.length,
          itemBuilder: (context, index) {
            final movie = turDizi[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Detaysayfa(movie)),
                );
              },
              child: Card(
                elevation: 10,
                shadowColor: temaNesne.temaOku() ? Colors.white : Colors.black,
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.tealAccent, width: 2.0),
                ),
                child: ListTile(
                  leading:
                      movie.posterPath != null
                          ? Image.network(
                            "https://image.tmdb.org/t/p/w200${movie.posterPath}",
                            fit: BoxFit.cover,
                          )
                          : Icon(Icons.movie),
                  title: Text(movie.title ?? S.of(context).film_adi_yok),
                  subtitle: Text(movie.overview ?? ""),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
