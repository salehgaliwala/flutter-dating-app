import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String ? selectedUrl;

  const CustomWebView({this.selectedUrl});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  //final flutterWebviewPlugin = FlutterWebviewPlugin();
   late WebViewController _controller; 

  @override
  void initState() {
    super.initState();
  }

  denied() {
    Navigator.pop(context);
  }

  succeed(String url) {
    var params = url.split("access_token=");

    var endparam = params[1].split("&");

    Navigator.pop(context, endparam[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
          title: const Text("Facebook login"),),
          body: Center(
            child: WebView(
              initialUrl: widget.selectedUrl!,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: ((controller) {
                _controller=controller;
              }),
              onPageStarted:(url){
                if (url.contains("#access_token")) {
        succeed(url);
      }

      if (url.contains(
          "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
        denied();
      }
              },
              
            ),
          ),
    );
    
    WebView(
        initialUrl: widget.selectedUrl!,
       /* appBar: AppBar(
          backgroundColor: Color.fromRGBO(66, 103, 178, 1),
          title: Text("Facebook login"),
        );*/);
  }
}
