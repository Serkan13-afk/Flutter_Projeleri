import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yemek_siparis_uyg/Meal.dart';
import 'package:yemek_siparis_uyg/WebSayfasi.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Youtubeplayer extends StatefulWidget {
  late Meal meal;

  Youtubeplayer(this.meal);

  @override
  State<Youtubeplayer> createState() => _YoutubeplayerState();
}

class _YoutubeplayerState extends State<Youtubeplayer> {
  late YoutubePlayerController youtubeplayerController;

  Widget youtubeVideoparcasi() {
    return Center(
      child: YoutubePlayer(
        controller: youtubeplayerController,
        showVideoProgressIndicator:
            true, // alt tarafta yüklenme çubuğu görünsün
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    var videoId = YoutubePlayer.convertUrlToId("${widget.meal.strYoutube}");
    if (videoId != null) {
      youtubeplayerController = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: YoutubePlayerFlags(
          autoPlay: false, //sayfa açıldığı gibi video oynamasın
          mute: false, // ses açık olsun dedik
        ),
      );
    } else {
      print("geçersiz url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text("Yemek Detaylari", style: TextStyle(fontSize: 27)),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),

              Text(
                "🍽️ ${widget.meal.strMeal} 🍽️",
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(height: 20),
              Text(
                "📌 Kategori: ${widget.meal.strCategory}",
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 5),

              Text(
                "📌 Mutfak: ${widget.meal.strArea}",
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 5),

              Text(
                "📌 Etiket: ${widget.meal.strTags}",
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 5),

              SizedBox(height: 30),
              youtubeVideoparcasi(),
              SizedBox(height: 50),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Websayfasi("${widget.meal.strSource}"),
                    ),
                  );
                },
                child: Text(
                  "👉 Detaylar için web sayfasını ziyaret edin",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  side: BorderSide(color: Colors.greenAccent, width: 2.0),
                  shadowColor: Colors.white,
                  elevation: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
