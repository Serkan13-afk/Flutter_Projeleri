import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Websayfasi extends StatefulWidget {
  late int id;

  Websayfasi(this.id);

  @override
  State<Websayfasi> createState() => _WebsayfasiState();
}

class _WebsayfasiState extends State<Websayfasi> {
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    webViewController =
        WebViewController()..loadRequest(
          Uri.parse("https://www.themoviedb.org/movie/${widget.id}"),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: webViewController));
  }
}
