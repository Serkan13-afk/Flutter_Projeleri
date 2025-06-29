import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gosteris/YiyecekVeIcecek.dart';

class SepetCubit extends Cubit<List<YiyecekVeIcecek>> {
  // Başlangıç durumu boş bir liste olmalı
  SepetCubit() : super([]);

  // Listeye yeni veri ekler
  void veriEkle(YiyecekVeIcecek veri) {
    // Mevcut listeyi kopyalayarak üzerine yeni veriyi ekle
    List<YiyecekVeIcecek> guncelListe = List.from(state)..add(veri);

    // Yeni listeyi state olarak yay
    emit(guncelListe);
  }
  void veriSil(YiyecekVeIcecek verim) {
    // İsme göre eşleşmeyenleri filtrele
    List<YiyecekVeIcecek> guncelListe = state.where((veri) => veri.ad != verim.ad).toList();

    // Yeni listeyi yay
    emit(guncelListe);
  }
}