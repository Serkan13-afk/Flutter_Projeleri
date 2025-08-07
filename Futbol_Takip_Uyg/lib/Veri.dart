class Veri {
  late String id;
  late String tur;
  late String url;

  Veri(this.id, this.tur, this.url);

  factory Veri.fromJson(Map<dynamic, dynamic> json) {
    return Veri(json["id"] as String, json["tur"] as String, json["url"]);
  }
}

/*
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("resimler/futbol_pp.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 400,
                    height: 378,
                    child: Lottie.asset("iconlar/futbolcu.json"),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      width: 400,
                      child: TextField(
                        maxLength: 25,
                        obscureText: false,
                        controller: kulaniciAdiControl,
                        decoration: InputDecoration(
                          label: Text("Kulanıcı Adınızı Giriniz"),
                          labelStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          filled: true,
                          fillColor: Colors.black54,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      width: 300,
                      child: TextField(
                        maxLength: 10,
                        obscureText: true,
                        controller: sifreControl,
                        decoration: InputDecoration(
                          label: Text("Şifrenizi Giriniz"),
                          labelStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          filled: true,
                          fillColor: Colors.black54,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: animationDegerleri.value,
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          girisKontrolOnce(
                            kulaniciAdiControl.text.trim(),
                            sifreControl.text.trim(),
                          );
                          // Fire base verileri
                        },
                        child: Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Colors.white,
                          child: Text(
                            "Giriş Yap",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 10,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Align(
                                alignment: Alignment.center,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.white54,
                                  highlightColor: Colors.white,
                                  child: Text(
                                    "Şifremi Unuttum Sayfasi",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: SizedBox(
                                  width: 300,
                                  height: 500,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 20,
                                          ),
                                          child: SizedBox(
                                            width: 400,
                                            child: TextField(
                                              maxLength: 25,
                                              obscureText: false,
                                              controller:
                                                  kulaniciAdiSifremiUnuttumControl,
                                              decoration: InputDecoration(
                                                label: Text(
                                                  "Kulanıcı Adınızı Giriniz",
                                                ),
                                                labelStyle: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                filled: true,
                                                fillColor: Colors.black54,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 20,
                                          ),
                                          child: SizedBox(
                                            width: 300,
                                            child: TextField(
                                              maxLength: 15,
                                              controller:
                                                  sifreSifremiUnuttumControl,
                                              decoration: InputDecoration(
                                                label: Text(
                                                  "Yeni Şifrenizi Giriniz",
                                                ),
                                                labelStyle: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                filled: true,
                                                fillColor: Colors.black54,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 20,
                                          ),
                                          child: SizedBox(
                                            width: 300,
                                            child: TextField(
                                              maxLength: 15,
                                              obscureText: true,
                                              controller:
                                                  sifreSifremiUnuttum2Control,
                                              decoration: InputDecoration(
                                                label: Text(
                                                  "Yeni Şifrenizi Tekrar Giriniz",
                                                ),
                                                labelStyle: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                filled: true,
                                                fillColor: Colors.black54,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: 120,
                                              height: 40,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  await sifreUnuttum(
                                                    kulaniciAdiSifremiUnuttumControl
                                                        .text
                                                        .trim(),
                                                    sifreSifremiUnuttumControl
                                                        .text
                                                        .trim(),
                                                    sifreSifremiUnuttum2Control
                                                        .text
                                                        .trim(),
                                                  );
                                                },
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.black,
                                                  highlightColor: Colors.white,
                                                  child: Text(
                                                    "Tamam",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.indigo,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              height: 40,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.white54,
                                                        highlightColor:
                                                            Colors.white,
                                                        child: Text(
                                                          "Şifre değiştirme işlemi iptal edildi",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                        milliseconds: 3000,
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                },
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.black,
                                                  highlightColor: Colors.white,
                                                  child: Text(
                                                    "İptal",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.indigo,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.blueGrey,
                            );
                          },
                        );
                      },
                      child: Shimmer.fromColors(
                        baseColor: Colors.black,
                        highlightColor: Colors.cyanAccent,
                        child: Text(
                          "Şifrenimi unuttun geri alalım hemen ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: 30, top: 20),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: Colors.black,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.blueGrey,
                                title: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: Text(
                                      "Kayıt Sayfası",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                content: SizedBox(
                                  width: 300,
                                  height: 450,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 20),
                                          child: TextField(
                                            controller: kulaniciAdi2Control,
                                            maxLength: 25,
                                            decoration: InputDecoration(
                                              label: Text(
                                                "Geçerli bir mail adresi giriniz",
                                              ),
                                              labelStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                              filled: true,
                                              fillColor: Colors.blue,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          controller: sifre2Control,
                                          maxLength: 10,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            label: Text(
                                              "Geçerli bir şifre giriniz",
                                            ),
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                            filled: true,
                                            fillColor: Colors.blue,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 30),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    duration: Duration(
                                                      milliseconds: 3000,
                                                    ),
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                      "Kayıt işlemi iptal edildi",
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.black,
                                                highlightColor: Colors.white,
                                                child: Text(
                                                  "İptal",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.indigo,
                                              ),
                                            ),

                                            ElevatedButton(
                                              onPressed: () async {
                                                await kisiEkle(
                                                  kulaniciAdi2Control.text,
                                                  sifre2Control.text,
                                                );
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    duration: Duration(
                                                      milliseconds: 3000,
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                    content: Text(
                                                      "Kayıt işlemi başarılı bir şekilde yapıldı",
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.black,
                                                highlightColor: Colors.white,
                                                child: Text(
                                                  "Tamam",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.indigo,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Icon(Icons.add, size: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

 */