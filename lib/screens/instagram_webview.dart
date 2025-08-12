import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InstagramWebView extends StatefulWidget {
  final String initialUrl;

  const InstagramWebView({super.key, required this.initialUrl});

  @override
  State<InstagramWebView> createState() => _InstagramWebViewState();
}

class _InstagramWebViewState extends State<InstagramWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Instagram Bağlantısı")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
