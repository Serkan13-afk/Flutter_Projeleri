import 'package:flutter/material.dart';
import 'package:havadurumu_app/HavaDurumuModel/HavadurumuModel.dart';
import 'package:havadurumu_app/Providerler.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Grafiksayfa extends StatefulWidget {
  final List<HavadurumuModel> gelecekveri;

  const Grafiksayfa(this.gelecekveri, {super.key});

  @override
  State<Grafiksayfa> createState() => _GrafiksayfaState();
}

class _GrafiksayfaState extends State<Grafiksayfa> {
  List<GrafikModel> grafik1 = [];
  List<GrafikModel> grafik2 = [];

  Future<void> veriler() async {
    List<GrafikModel> g1 = [];
    List<GrafikModel> g2 = [];

    for (var veri in widget.gelecekveri) {
      var girilecekGun = veri.gun
          .replaceAll("Pazartesi", "Pzrt")
          .replaceAll("Salı", "Salı")
          .replaceAll("Çarşamba", "Çarş")
          .replaceAll("Perşembe", "Perş")
          .replaceAll("Cuma", "Cuma")
          .replaceAll("Cumartesi", "Cmrt")
          .replaceAll("Pazar", "Paz");

      g1.add(GrafikModel(girilecekGun, veri.derece));
      g2.add(GrafikModel(girilecekGun, veri.nem));
    }

    setState(() {
      grafik1 = g1;
      grafik2 = g2;
    });
  }

  @override
  void initState() {
    super.initState();
    veriler();
  }

  Widget grafikOne() {
    return SfCartesianChart(
      title: ChartTitle(text: 'Günlük Ortalama Sıcaklık (°C)'),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: CategoryAxis(
        title: AxisTitle(
          text: 'Günler', // X ekseni başlığı
          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),

      // 🟢 Y ekseni
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: 'Sıcaklık (°C)', // Y ekseni başlığı
          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        minimum: 0,
        maximum: 30,
        interval: 5,
      ),
      series: <CartesianSeries<GrafikModel, String>>[
        LineSeries<GrafikModel, String>(
          dataSource: grafik1,
          xValueMapper: (v, _) => v.gun,
          yValueMapper: (v, _) => double.tryParse(v.kulanilicakVeri) ?? 0,
          name: 'Sıcaklık',
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget grafikTwo() {
    return SfCartesianChart(
      title: ChartTitle(text: 'Günlük Ortalama Nem (%)'),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Günler')),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Nem (%)'),
        minimum: 0,
        maximum: 70,
        interval: 10,
      ),
      series: <CartesianSeries<GrafikModel, String>>[
        ColumnSeries<GrafikModel, String>(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          dataSource: grafik2,
          xValueMapper: (v, _) => v.gun,
          yValueMapper: (v, _) => double.tryParse(v.kulanilicakVeri) ?? 0,
          name: "Nem",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TemaOkuma>(
      builder: (context, temaNesne, child) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: temaNesne.temaOku()
                    ? [Colors.white, Colors.cyanAccent]
                    : [Colors.black, Colors.cyanAccent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    grafikOne(),
                    const SizedBox(height: 20),
                    grafikTwo(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class GrafikModel {
  final String gun;
  final String kulanilicakVeri;

  GrafikModel(this.gun, this.kulanilicakVeri);
}
