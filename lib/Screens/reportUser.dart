import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seting/models/user_model.dart';
import 'package:seting/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

class ReportUser extends StatefulWidget {
  final User currentUser;
  final User seconduser;

  const ReportUser({required this.currentUser, required this.seconduser});

  @override
  _ReportUserState createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> {
  TextEditingController reasonCtlr = TextEditingController();
  bool other = false;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Container(
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Icon(
                Icons.security,
                color: primaryColor,
                size: 35,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Report User".tr().toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            Text(
              "Is this person bothering you? Tell us what they did.".tr().toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
      actions: !other
          ? <Widget>[
              Material(
                child: ListTile(
                    title: Text("Inappropriate Photos".tr().toString()),
                    leading: const Icon(
                      Icons.camera_alt,
                      color: Colors.indigo,
                    ),
                    onTap: () => _newReport(context, "Inappropriate Photos")
                        .then((value) => Navigator.pop(context))),
              ),
              Material(
                child: ListTile(
                    title: Text(
                      "Feels Like Spam".tr().toString(),
                    ),
                    leading: const Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.orange,
                    ),
                    onTap: () => _newReport(context, "Feels Like Spam")
                        .then((value) => Navigator.pop(context))),
              ),
              Material(
                child: ListTile(
                    title: Text(
                      "User is underage".tr().toString(),
                    ),
                    leading: const Icon(
                      Icons.call_missed_outgoing,
                      color: Colors.blue,
                    ),
                    onTap: () => _newReport(context, "User is underage")
                        .then((value) => Navigator.pop(context))),
              ),
              Material(
                child: ListTile(
                    title: Text(
                      "Other".tr().toString(),
                    ),
                    leading: const Icon(
                      Icons.report_problem,
                      color: Colors.green,
                    ),
                    onTap: () {
                      setState(() {
                        other = true;
                      });
                    }),
              ),
            ]
          : <Widget>[
              Material(
                  child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: reasonCtlr,
                      decoration: InputDecoration(
                          hintText: "Additional Info(optional)".tr().toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton(
                          //color: primaryColor,
                          child: Text(
                            "Report User".tr().toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _newReport(context, reasonCtlr.text)
                                .then((value) => Navigator.pop(context));
                          }),
                    )
                  ],
                ),
              ))
            ],
    );
  }

  Future _newReport(context, String reason) async {
    await FirebaseFirestore.instance.collection("Reports").add({
      'reported_by': widget.currentUser.id,
      'victim_id': widget.seconduser.id,
      'reason': reason,
      'timestamp': FieldValue.serverTimestamp()
    });
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pop(context);
          });
          return Center(
              child: Container(
                  width: 150.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "asset/auth/verified.jpg",
                        height: 60,
                        color: primaryColor,
                        colorBlendMode: BlendMode.color,
                      ),
                      Text(
                        "Reported".tr().toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontSize: 20),
                      )
                    ],
                  )));
        });
  }
}