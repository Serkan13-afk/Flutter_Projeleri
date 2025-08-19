import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis_uyg/Meal.dart';
import 'package:yemek_siparis_uyg/SepetBlocState.dart';

class SepetCubit extends Cubit<SepetBlocState> {
  SepetCubit() : super(SepetBlocState.inirial()); // Sepet yapısı

  void veriEkle(Meal meal) {
    List<Meal> guncelListe = List<Meal>.from(state.sepetListesi)..add(meal);
    var yeniFiyat = state.toplamTutar + 40;

    emit(SepetBlocState(sepetListesi: guncelListe, toplamTutar: yeniFiyat));
  }

  void veriSil(Meal meals) {
    var guncelListe = List<Meal>.from(state.sepetListesi);

    int index = guncelListe.indexWhere((m) => m.strMeal == meals.strMeal); // Silinecek öğenin index'ini buluyoruz (ilk eşleşen)

    if (index != -1) {
      // aranan index bulunduysa

      guncelListe.removeAt(index);
      var yeniFiyat = state.toplamTutar - 40;
      if (yeniFiyat < 0) {
        yeniFiyat = 0;
      }
      emit(SepetBlocState(sepetListesi: guncelListe, toplamTutar: yeniFiyat));
    }
  }

  void sepetiTemizle() {
    emit(SepetBlocState(sepetListesi: [], toplamTutar: 0));
  }
}
