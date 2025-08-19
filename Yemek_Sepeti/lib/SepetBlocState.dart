import 'Meal.dart';

class SepetBlocState {
  late List<Meal> sepetListesi;
  late double toplamTutar;

  SepetBlocState({required this.sepetListesi, required this.toplamTutar});

  factory SepetBlocState.inirial() {
    // Bizim baştaki  değerlerimiz olcak
    return SepetBlocState(sepetListesi: [], toplamTutar: 0);
  }
}
