import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Websayfalari extends StatefulWidget {
  late String url;
  late String sosyalMedyaIsmi;


  Websayfalari(this.url,this.sosyalMedyaIsmi);

  @override
  State<Websayfalari> createState() => _WebsayfalariState();
}

class _WebsayfalariState extends State<Websayfalari> {
  late WebViewController webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webViewController =
        WebViewController()..loadRequest(Uri.parse("${widget.url}"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Shimmer.fromColors(
          baseColor: Colors.cyan,
          highlightColor: Colors.black,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "${widget.sosyalMedyaIsmi}",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: WebViewWidget(controller: webViewController),
    );
  }
}
