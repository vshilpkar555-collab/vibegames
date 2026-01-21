import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebGamePage extends StatefulWidget {
  final String url;
  final String title;
  const WebGamePage({required this.url, required this.title, super.key});

  @override
  State<WebGamePage> createState() => _WebGamePageState();
}

class _WebGamePageState extends State<WebGamePage> {
  late final WebViewController _controller;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    // Allow landscape + portrait in this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(onProgress: (p) {
          setState(() {
            progress = p / 100;
          });
        }),
      )
      ..loadRequest(Uri.parse(widget.url));
  }


  @override
  void dispose() {
    // Re-lock app to portrait when exiting
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          )
        ],
      ),
      body: Column(
        children: [
          if (progress < 1.0) LinearProgressIndicator(value: progress),
          Expanded(child: WebViewWidget(controller: _controller)),
        ],
      ),
    );
  }
}
