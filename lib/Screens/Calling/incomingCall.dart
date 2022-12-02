import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:seting/util/color.dart';
import 'package:shimmer/shimmer.dart';
import '../Chat/chatPage.dart';
import 'call.dart';
import 'package:easy_localization/easy_localization.dart';

class Incoming extends StatefulWidget {
  final callInfo;
  const Incoming(this.callInfo, {super.key});

  @override
  _IncomingState createState() => _IncomingState();
}

class _IncomingState extends State<Incoming> with TickerProviderStateMixin {
  CollectionReference callRef = FirebaseFirestore.instance.collection("calls");

  bool ispickup = false;
  late AnimationController _controller;

  @override
  void initState() {
    print('incoming call called~~~~~~~~~~~~~~~~~~~~');
    super.initState();
    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true, // Android only - API >= 28
      volume: 1, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() async {
    _controller.dispose();
    await FlutterRingtonePlayer.stop();
    ispickup = true;
    super.dispose();
    await callRef.doc(widget.callInfo['channel_id']).update({'calling': false});
    print('-------------incoming dispose-----------');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: AppBar(
          //   centerTitle: true,
          //   elevation: 0,
          //   backgroundColor: Colors.white,
          //   title: Text(
          //     "Incoming Call",
          //     style: TextStyle(color: Colors.red),
          //   ),
          // ),
          body: Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: callRef
                  .where("channel_id",
                      isEqualTo: "${widget.callInfo['channel_id']}")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                // Future.delayed(Duration(seconds: 30), () async {
                //   if (!ispickup) {
                //     await callRef
                //         .doc(widget.callInfo['channel_id'])
                //         .update({'response': 'Not-answer'});
                //   }
                //   Navigator.pop(context);
                // });
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  try {
                    //        if (snapshot.data!.docs[0]['calling']) {
                    if (snapshot.data!.docs[0]['response'] == 'Awaiting') {
                      //wait for pick the call
                      //      case "Awaiting":

                      print(
                          'snapshot values are ${snapshot.data!.docs[0]['response']}');

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            snapshot.data!.docs[0]['callType'] == "VideoCall"
                                ? "Incoming Video Call".tr().toString()
                                : "Incoming Audio Call".tr().toString(),
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          AnimatedBuilder(
                              animation: CurvedAnimation(
                                  parent: _controller,
                                  curve: Curves.slowMiddle),
                              builder: (context, child) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .3,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      _buildContainer(150 * _controller.value),
                                      _buildContainer(200 * _controller.value),
                                      _buildContainer(250 * _controller.value),
                                      _buildContainer(300 * _controller.value),
                                      //_buildContainer(350 * _controller.value),
                                      // Align(
                                      //     child: Icon(
                                      //   Icons.phone_android,
                                      //   size: 44,
                                      // )),

                                      CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        radius: 60,
                                        child: Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              60,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: widget.callInfo[
                                                      'senderPicture'] ??
                                                  '',
                                              useOldImageOnUrlChange: true,
                                              placeholder: (context, url) =>
                                                  const CupertinoActivityIndicator(
                                                radius: 15,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  const Icon(
                                                    Icons.error,
                                                    color: Colors.black,
                                                    size: 30,
                                                  ),
                                                  Text(
                                                    "Unable to load"
                                                        .tr()
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "${widget.callInfo['senderName']} ",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: Colors.black,
                                child: Text(
                                  "is calling you...".tr().toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                FloatingActionButton(
                                    heroTag: UniqueKey(),
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      snapshot.data!.docs[0]['callType'] ==
                                              "VideoCall"
                                          ? Icons.video_call
                                          : Icons.call,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      await handleCameraAndMic(
                                          snapshot.data!.docs[0]['callType']);
                                      ispickup = true;
                                      await callRef
                                          .doc(widget.callInfo['channel_id'])
                                          .update({'response': "Pickup"});
                                      await FlutterRingtonePlayer.stop();
                                    }),
                                FloatingActionButton(
                                    heroTag: UniqueKey(),
                                    backgroundColor: Colors.red,
                                    child:
                                        const Icon(Icons.clear, color: Colors.white),
                                    onPressed: () async {
                                      await callRef
                                          .doc(widget.callInfo['channel_id'])
                                          .update({'response': 'Decline'});

                                      print(
                                          'decilne incoming dart------------------------------------');
                                      Future.delayed(
                                          const Duration(milliseconds: 500), () {
                                        Navigator.pop(context);
                                      });
                                    })
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    //    break;
                    // push video page with given channel name
                    //    case "Pickup":
                    else if (snapshot.data!.docs[0]['response'] == 'Pickup') {
                      print(
                          "call is picked up ${widget.callInfo['channel_id']} , callType ${snapshot.data!.docs[0]['callType']}");
                      return CallPage(
                        channelName: widget.callInfo['channel_id'],
                        role: ClientRole.Broadcaster,
                        callType: snapshot.data!.docs[0]['callType'],
                      );
                    }

                    //call end
                    else if ((snapshot.data!.docs[0]['response'] ==
                        "Call_Cancelled"))
                    // !(snapshot.data!.docs[0]['response'] ==
                    //       'Pickup' ||
                    //   snapshot.data!.docs[0]['response'] == 'Awaiting'))
                    {
                      print('call ended ${snapshot.data!.docs[0]['response']}');
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pop(context);
                      });
                      return Text("Call Ended...".tr().toString());
                    }
                    //   }
                    // else if (snapshot.data!.docs[0]['response'] ==
                    //     "Call_Cancelled") {
                    //   return Container(
                    //     child: Text("Missed call"),
                    //   );
                    // }
                    else if (snapshot.data!.docs[0]['response'] == "Decline") {
                      //FlutterRingtonePlayer.stop();

                      print('decilne ------------------------------------');
                      return const Text("Decline call");
                    } else {
                      print('default is print');
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pop(context);
                      });
                      return Container(
                        child: Text("Call Ended...".tr().toString()),
                      );
                    }
                  } catch (e) {
                    print('errrrrrrrrrrrrrr $e');
                    return Container();
                  }
                }

                // return Container(
                //   child: InkWell(
                //     child: Text('Call has ended \n Tap here'),
                //     onTap: () {
                //       Navigator.pop(context);
                //     },
                //   ),
                // );
              },
            ),
          ),
        ));
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withOpacity(1 - _controller.value),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return false;
  }
}
