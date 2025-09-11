import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/KayitSepetState.dart';
import 'package:movieapp/Movie.dart';

class KayitliCubit extends Cubit<KayitSepetState> {
  KayitliCubit() : super(KayitSepetState.inirial()); // Sepet yapısı

  void veriEkle(Movie movie) {
    bool ekliMi = false;
    var guncelListe = List<Movie>.from(state.sepetListe);
    var yeniSayi = state.kayitliSayisi;

    for (var veri in guncelListe) {
      if (veri.title == movie.title) {
        ekliMi = true;
      }
    }
    if (ekliMi) {
      emit(KayitSepetState(guncelListe, yeniSayi));
    } else {
      List<Movie> guncelListem2 = List<Movie>.from(state.sepetListe)
        ..add(movie);
      var yeniSayi2 = state.kayitliSayisi + 1;
      emit(KayitSepetState(guncelListem2, yeniSayi2));
    }
  }

  void veriSil(Movie movie) {
    var guncelListe = List<Movie>.from(state.sepetListe)..remove(movie);
    var yeniSayi = state.kayitliSayisi - 1;
    emit(KayitSepetState(guncelListe, yeniSayi));
  }

  void kayitSayfasiniBosalt() {
    emit(KayitSepetState([], 0));
  }
}
