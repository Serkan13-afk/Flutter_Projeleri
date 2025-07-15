import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kripto_uyg/Coin.dart';

class FavoriCoinCubit extends Cubit<List<Coin>> {
  FavoriCoinCubit() : super([]);

  void veriEkle(Coin coin) {
    List<Coin> guncelListe = List.from(state)..add(coin);
    emit(guncelListe);
  }

  void veriSil(Coin coin) {
    List<Coin> guncelListe = state.where((veri) => veri.isim != coin.isim).toList();

    emit(guncelListe);
  }
}
