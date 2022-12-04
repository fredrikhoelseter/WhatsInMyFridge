import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// if user clicks on recipe, this page will display webpage view of original recipes

class RecipeView extends StatefulWidget {
  final String postUrl;
  RecipeView({required this.postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  late String finalUrl;

  @override
  void initState() {
    super.initState();
    finalUrl = widget.postUrl;
    if (widget.postUrl.contains('http://')) {
      finalUrl = widget.postUrl.replaceAll("http://", "https://");
      print(finalUrl + "this is final url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height:
              MediaQuery.of(context).size.height - (Platform.isIOS ? 104 : 30),
          width: MediaQuery.of(context).size.width,
          child: WebView(
            onPageFinished: (val) {
              print(val);
            },
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: finalUrl,
            onWebViewCreated: (WebViewController webViewController) {
              setState(() {
                _controller.complete(webViewController);
              });
            },
          ),
        ),
      ),
    );
  }
}
