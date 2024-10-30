import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  WebViewController? _controller;
  String customUrl = "https://www.google.com/";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(customUrl)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(customUrl));
  }

  Future<bool> _onWillPop() async {
    if (await _controller!.canGoBack()) {
      // If the web view can go back, navigate back in web view
      _controller!.goBack();
      return false; // Prevent the default back button behavior
    } else {
      // Show exit dialog
      return await _showExitDialog(context) ?? false;
    }
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit'),
          content: const Text('Do you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / (size.height);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : AspectRatio(
                  aspectRatio: deviceRatio,
                  child: WebViewWidget(controller: _controller!),
                ),
        ),
      ),
    );
  }
}
