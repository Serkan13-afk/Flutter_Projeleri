class YiyecekVeIcecek{
  late String id;
  late String ad;
  late String fiyat;
  late String resim_url;
  late String tur;
  late String aciklama;

  YiyecekVeIcecek(this.id,this.ad, this.fiyat, this.resim_url, this.tur,this.aciklama);

  factory YiyecekVeIcecek.fromJson(Map<String, dynamic> json) {
    return YiyecekVeIcecek(
      json["id"] as String,
      json["ad"] as String,
      json["fiyat"] as String,
      json["resim_url"] as String,
      json["tur"] as String,
      json["aciklama"] as String
    );
  }
}
/* ListView.builder(
                    itemCount: kategoriler!.length,
                    itemBuilder: (context, index) {
                      var kategori = kategoriler[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Filmlersayfa(kategori),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 100,
                          child: Card(
                            color: Colors.cyanAccent,
                            elevation: 10,
                            shadowColor: Colors.black,
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.white,
                                    highlightColor: Colors.green,
                                    child: Text(
                                      kategori.kategori_ad,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );*/

