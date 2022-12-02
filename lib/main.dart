
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'Screens/Splash.dart';
import 'Screens/Tab.dart';
import 'Screens/Welcome.dart';
import './Screens/auth/login.dart';

import './util/color.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((_) {
  InAppPurchaseConnection.enablePendingPurchases();
  
    
    //runApp(new MyApp());
    runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('es', 'ES')],
      path: 'asset/translation',
      saveLocale: true,
      fallbackLocale: const Locale('en', 'US'),
      child: MyApp(),
    ));
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isAuth = false;
  bool isRegistered = false;
  List<String> testID = ['2DAA04BF7929E5D7DE7EE279D00172FA'];

  @override
  void initState() {
    super.initState();
    _checkAuth();
    MobileAds.instance.initialize();
    RequestConfiguration configuration =
        RequestConfiguration(testDeviceIds: testID);
    MobileAds.instance.updateRequestConfiguration(configuration);
    // FirebaseAdMob.instance
    //     .initialize(appId: Platform.isAndroid ? androidAdAppId : iosAdAppId);
    _getLanguage();
  }

  Future _checkAuth() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user =  auth.currentUser;
    //_auth.currentUser.().then((User user) async {
    //print(user!.uid);
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .where('userId', isEqualTo: user.uid)
          .get()
          .then((QuerySnapshot snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          if (snapshot.docs[0].get('location') != null) {
            setState(() {
              isRegistered = true;
              isLoading = false;
            });
          } else {
            setState(() {
              isAuth = true;
              isLoading = false;
            });
          }
          print("loggedin ${user.uid}");
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
    //});
  }

  _getLanguage() async {
    var itemList = await FirebaseFirestore.instance
        .collection('Language')
        .doc('present_languages')
        .get();

    if (itemList.data()!['spanish'] == true &&
        itemList.data()!['english'] == false) {
      setState(() {
        EasyLocalization.of(context)!.setLocale(const Locale('es', 'ES'));
      });
    }
    if (itemList.data()!['english'] == true &&
        itemList.data()!['spanish'] == false) {
      setState(() {
        EasyLocalization.of(context)!.setLocale(const Locale('en', 'US'));
      });
    }

    return EasyLocalization.of(context)!.locale;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: isLoading
          ? Splash()
          : isRegistered
              ? const Tabbar(null, null)
              : isAuth
                  ? Welcome()
                  : Login(),
    );
  }
}
