import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gosteris/YiyecekVeIcecek.dart';

class FavoriCubit extends Cubit<List<YiyecekVeIcecek>> {
  FavoriCubit() : super([]);

  void veriEkle(YiyecekVeIcecek veri) {

    List<YiyecekVeIcecek> guncelListe = List.from(state)..add(veri);

    emit(guncelListe);
  }

  void veriSil(YiyecekVeIcecek verim) {
    List<YiyecekVeIcecek> guncelListe =
        state.where((veri) => veri.ad != verim.ad).toList();

    emit(guncelListe);
  }
}
