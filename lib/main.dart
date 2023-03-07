import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const Webview()
    );
  }
}

class Webview extends StatefulWidget {
  const Webview({Key? key}) : super(key: key);

  @override
  State<Webview> createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {

  late final WebViewController controller;

  bool loading = true;
  bool internetIsAvailable = false;

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  void checkConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if(result == true) {
      setState(() {
        loading = false;
        internetIsAvailable = true;
      });
      controller = WebViewController()
        ..loadRequest(
          Uri.parse('https://sms.shekinahpps.sc.tz/login'),
        );
    } else {
      setState(() {
        loading = false;
        internetIsAvailable = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: SafeArea(
          child:
          !loading && internetIsAvailable ?WebViewWidget(controller: controller): Container(
              child: !loading && !internetIsAvailable ? Container(
                width: double.infinity,
                height: double.infinity,
                color: Color(0xff08223A),

                child: Column(
                  children: [

                    Container(
                       padding: EdgeInsets.only(top: 30),
                      alignment: Alignment.topCenter,
                      child: Image.asset("assets/logo.png"),
                    ),
                    // Expanded(child: Container()),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 20,right: 20,top: 50),
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            child: Center(child: Text("No internet connection",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,),)),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Container())
                  ],
                ),

              ) :LinearProgressIndicator(
                color: Colors.blue,
              )
          ),
        )
    );
  }
}
