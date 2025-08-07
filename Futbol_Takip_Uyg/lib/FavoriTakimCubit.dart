import 'package:flutter_bloc/flutter_bloc.dart';

import 'Takim.dart';

class FavoriCubit extends Cubit<List<Takim>> {
  FavoriCubit() : super([]); // Başta favori sayfası boş

  void veriEkle(Takim takim) {
    List<Takim> guncelListe = List.from(state)..add(takim);

    emit(guncelListe);
  }

  void veriSil(Takim takim) {
    List<Takim> guncelListe =
        state.where((veri) => veri.takimAdi != takim.takimAdi).toList();

    emit(guncelListe);
  }


}
