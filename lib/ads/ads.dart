// import 'dart:io';
// import 'package:firebase_admob/firebase_admob.dart';

// // You can also test with your own ad unit IDs by registering your device as a
// // test device. Check the logs for your device's ID value.
// const String testDevice = 'YOUR_DEVICE_ID';

// //Admob App id's with '~' sign
// String androidAdAppId = FirebaseAdMob.testAppId;
// String iosAdAppId = FirebaseAdMob.testAppId;
// //Banner unit id's with '/' sign
// String androidBannerAdUnitId = BannerAd.testAdUnitId;
// String iosBannerAdUnitId = BannerAd.testAdUnitId;
// //Interstitial unit id's with '/' sign
// String androidInterstitialAdUnitId = InterstitialAd.testAdUnitId;
// String iosInterstitialAdUnitId = InterstitialAd.testAdUnitId;

// class Ads {
//   MobileAdTargetingInfo targetingInfo() => MobileAdTargetingInfo(
//         contentUrl: 'https://flutter.io',
//         childDirected: false,
//         testDevices: testDevice != null
//             ? <String>[testDevice]
//             : null, // Android emulators are considered test devices
//       );

//   BannerAd myBanner() => BannerAd(
//         adUnitId: Platform.isIOS ? iosBannerAdUnitId : androidBannerAdUnitId,
//         size: AdSize.smartBanner,
//         targetingInfo: targetingInfo(),
//         listener: (MobileAdEvent event) {
//           print("BannerAd event is $event");
//         },
//       );
//   InterstitialAd myInterstitial() => InterstitialAd(
//         adUnitId: Platform.isAndroid
//             ? androidInterstitialAdUnitId
//             : iosInterstitialAdUnitId,
//         targetingInfo: targetingInfo(),
//         listener: (MobileAdEvent event) {
//           // adEvent = event;
//           print("------------------------------InterstitialAd event is $event");
//         },
//       );

//   void disable(ad) {
//     try {
//       ad?.dispose();
//     } catch (e) {
//       print("no ad found");
//     }
//   }
// }

import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
