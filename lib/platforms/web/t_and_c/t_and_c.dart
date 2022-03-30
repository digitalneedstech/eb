import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TAndCPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: "https://expertbunch-c5b78.web.app/terms/index.html",
    );
  }
}