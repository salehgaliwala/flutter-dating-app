import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seting/models/user_model.dart';
import 'package:easy_localization/easy_localization.dart';

import 'call.dart';

class DialCall extends StatefulWidget {
  final String channelName;
  final User receiver;
  final String callType;
  const DialCall(
      {required this.channelName,
      required this.receiver,
      required this.callType});

  @override
  _DialCallState createState() => _DialCallState();
}

class _DialCallState extends State<DialCall> {
  bool ispickup = false;
  //final db = Firestore.instance;
  CollectionReference callRef = FirebaseFirestore.instance.collection("calls");
  @override
  void initState() {
    _addCallingData();
    super.initState();
  }

  _addCallingData() async {
    await callRef.doc(widget.channelName).delete();
    await callRef.doc(widget.channelName).set({
      'callType': widget.callType,
      'calling': true,
      'response': "Awaiting",
      'channel_id': widget.channelName,
      'last_call': FieldValue.serverTimestamp()
    }, SetOptions(merge: true));
  }

  @override
  void dispose() async {
    super.dispose();
    ispickup = true;
    await callRef
        .doc(widget.channelName)
        .set({'calling': false}, SetOptions(merge: true));
    print('-------------dial dispose-----------');
  }

  @override
  Widget build(BuildContext context) {
    print('^^^^^^^^^^^^^^^^^${widget.channelName}, @@@${widget.receiver}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: callRef
              .where("channel_id", isEqualTo: widget.channelName)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // Future.delayed(Duration(seconds: 30), () async {
            //   if (!ispickup) {
            //     await callRef
            //         .doc(widget.channelName)
            //         .update({'response': 'Not-answer'});
            //   }
            // });
            if (!snapshot.hasData) {
              return Container();
            } else {
              try {
                if ((snapshot.data!.docs[0]['response']) == 'Awaiting') {
                  print('call is awaiting');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 60,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              60,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.receiver.imageUrl![0] ?? '',
                              useOldImageOnUrlChange: true,
                              placeholder: (context, url) =>
                                  const CupertinoActivityIndicator(
                                radius: 15,
                              ),
                              errorWidget: (context, url, error) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Icon(
                                    Icons.error,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  Text(
                                    "Unable to load".tr().toString(),
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
                      Text("Calling to ${widget.receiver.name}",
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                          //icon: primaryColor,
                          icon: const Icon(
                            Icons.call_end,
                            color: Colors.white,
                          ),
                          label: Text(
                            "END".tr().toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            await callRef.doc(widget.channelName).set(
                                {'response': "Call_Cancelled"},
                                SetOptions(merge: true));
                            // Navigator.pop(context);
                          })
                    ],
                  );
                }
                //     break;
                else if ((snapshot.data!.docs[0]['response']) == 'Pickup') {
                  print('call is pickedup');
                  ispickup = true;
                  return CallPage(
                      channelName: widget.channelName,
                      role: ClientRole.Broadcaster,
                      callType: widget.callType);
                } else if ((snapshot.data!.docs[0]['response']) == 'Decline')
                //        break;

                {
                  print(
                      'decilne dial dart------------------------------------');
                  print('call declined');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text("is Busy",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold))
                          .tr(args: ["${widget.receiver.name}"]),
                      ElevatedButton.icon(
                          //color: primaryColor,
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Back".tr().toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          })
                    ],
                  );
                }
                //       break;
                else if ((snapshot.data!.docs[0]['response']) == 'Awaiting') {
                  print('not answering');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text("is Not-answering",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold))
                          .tr(args: ["${widget.receiver.name}"]),
                      ElevatedButton.icon(
                          //color: primaryColor,
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Back".tr().toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          })
                    ],
                  );
                }
                //       break;
                //call end
                else {
                  print('default is print');
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pop(context);
                  });
                  return Text("Call Ended...".tr().toString());
                }
                //   break;
              }

              //  else if (!snapshot.data.documents[0]['calling']) {
              //   Navigator.pop(context);
              // }
              catch (e) {
                return Container();
              }
            }
          },
        ),
      ),
    );
  }
}
