import 'package:movieapp/Movie.dart';

class KayitSepetState {
  late List<Movie> sepetListe;
  late int kayitliSayisi;

  KayitSepetState(this.sepetListe, this.kayitliSayisi);

  factory KayitSepetState.inirial(){
    return KayitSepetState([], 0);

  }


}
