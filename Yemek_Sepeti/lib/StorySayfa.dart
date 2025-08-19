import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:yemek_siparis_uyg/Meal.dart';

class StorySayfasi extends StatelessWidget {
  late Meal tercihedilenyemek;

  StorySayfasi(this.tercihedilenyemek);

  var storycontroller = StoryController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StoryView(
        storyItems: [
          /*StoryItem.text(
            duration: Duration(milliseconds: 4000),
            title: "Favorilerde bugün",
            backgroundColor: Colors.cyanAccent,
          ),*/
          StoryItem.pageImage(
            caption: Text(
              "Açıklama:\n${tercihedilenyemek.strInstructions}",
              style: TextStyle(fontSize: 10, color: Colors.white),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
                maxLines:20
            ),
            duration: Duration(milliseconds: 4000),
            url: "${tercihedilenyemek.strMealThumb}",
            controller: storycontroller,
            shown: false,
          ),
        ],
        controller: storycontroller,
        repeat: false,
        onComplete: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
