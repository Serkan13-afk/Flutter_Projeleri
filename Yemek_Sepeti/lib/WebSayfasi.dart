import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Websayfasi extends StatefulWidget {
  late String webUrl;

  Websayfasi(this.webUrl);

  @override
  State<Websayfasi> createState() => _WebsayfasiState();
}

class _WebsayfasiState extends State<Websayfasi> {
  late WebViewController webViewController;

  Widget websayfasi() {
    if (widget.webUrl.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.white60,
              highlightColor: Colors.white,
              child: Text("Url hatalı", style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      );
    }
    return WebViewWidget(controller: webViewController);
  }

  @override
  void initState() {
    super.initState();
    webViewController =
        WebViewController()..loadRequest(Uri.parse("${widget.webUrl}"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: websayfasi());
  }
}
