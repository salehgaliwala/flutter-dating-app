import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seting/Screens/Information.dart';
import 'package:seting/models/user_model.dart';
import 'package:seting/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

import 'Tab.dart';

class Notifications extends StatefulWidget {
  final User currentUser;
  const Notifications(this.currentUser);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final db = FirebaseFirestore.instance;
  late CollectionReference matchReference;

  @override
  void initState() {
    matchReference = db
        .collection("Users")
        .doc(widget.currentUser.id)
        .collection('Matches');

    super.initState();
    // Future.delayed(Duration(seconds: 1), () {
    //   if (widget.notification.length > 1) {
    //     widget.notification.sort((a, b) {
    //       var adate = a.time; //before -> var adate = a.expiry;
    //       var bdate = b.time; //before -> var bdate = b.expiry;
    //       return bdate.compareTo(
    //           adate); //to get the order other way just switch `adate & bdate`
    //     });
    //   }
    // });
    // if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
          
        //   automaticallyImplyLeading: false,
        //   title: Text(
        //     'Notifications'.tr().toString(),
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontSize: 18.0,
        //       fontWeight: FontWeight.bold,
        //       letterSpacing: 1.0,
        //     ),
        //   ),
        //   elevation: 0,
        // ),
        backgroundColor: primaryColor,
        body: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              color: Colors.white),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.all(10),
                //   child: Text(
                //     'this week',
                //     style: TextStyle(
                //       color: primaryColor,
                //       fontSize: 18.0,
                //       fontWeight: FontWeight.bold,
                //       letterSpacing: 1.0,
                //     ),
                //   ),
                // ),
                StreamBuilder<QuerySnapshot>(
                    stream: matchReference
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: Text(
                          "No Notification".tr().toString(),
                          style: TextStyle(color: secondryColor, fontSize: 16),
                        ));
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text(
                          "No Notification".tr().toString(),
                          style: TextStyle(color: secondryColor, fontSize: 16),
                        ));
                      }
                      return Expanded(
                        child: ListView(
                          children: snapshot.data!.docs
                              .map((doc) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: !doc.get('isRead')
                                                ? primaryColor.withOpacity(.15)
                                                : secondryColor
                                                    .withOpacity(.15)),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(5),
                                          leading: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: secondryColor,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                25,
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    doc.get('pictureUrl') ??
                                                        "",
                                                fit: BoxFit.cover,
                                                useOldImageOnUrlChange: true,
                                                placeholder: (context, url) =>
                                                    const CupertinoActivityIndicator(
                                                  radius: 20,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                  Icons.error,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            // backgroundImage:
                                            //     NetworkImage(
                                            //   widget.notification[index]
                                            //       .sender.imageUrl[0],
                                            // )
                                          ),
                                          // title: Text(
                                          //     "you are matched with ${doc.data['userName'] ?? "__"}".tr().toString()),
                                          title: const Text("you are matched with")
                                              .tr(args: [
                                            "${doc.get('userName') ?? '__'}"
                                          ]),

                                          subtitle: Text(
                                              "${(doc.get('timestamp').toDate())}"),
                                          //  Text(
                                          //     "Now you can start chat with ${notification[index].sender.name}"),
                                          // "if you want to match your profile with ${notifications[index].sender.name} just like ${notifications[index].sender.name}'s profile"),
                                          trailing: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                !doc.get('isRead')
                                                    ? Container(
                                                        width: 40.0,
                                                        height: 20.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'NEW',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      )
                                                    : const Text(""),
                                              ],
                                            ),
                                          ),
                                          onTap: () async {
                                            print(doc.get("Matches"));
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white),
                                                  ));
                                                });
                                            DocumentSnapshot userdoc = await db
                                                .collection("Users")
                                                .doc(doc.get("Matches"))
                                                .get();
                                            if (userdoc.exists) {
                                              Navigator.pop(context);
                                              User tempuser =
                                                  User.fromDocument(userdoc);
                                              tempuser.distanceBW =
                                                  calculateDistance(
                                                          widget.currentUser
                                                                  .coordinates![
                                                              'latitude'],
                                                          widget.currentUser
                                                                  .coordinates![
                                                              'longitude'],
                                                          tempuser.coordinates![
                                                              'latitude'],
                                                          tempuser.coordinates![
                                                              'longitude'])
                                                      .round();

                                              await showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    if (!doc.get("isRead")) {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "/Users/${widget.currentUser.id}/Matches")
                                                          .doc(
                                                              '${doc.get("Matches")}')
                                                          .update(
                                                              {'isRead': true});
                                                    }
                                                    return Info(
                                                        tempuser,
                                                        widget.currentUser,
                                                        null);
                                                  });
                                            }
                                          },
                                        )
                                        //  : Container()
                                        ),
                                  ))
                              .toList(),
                        ),
                      );
                    })
              ],
            ),
          ),
        ));
  }
}
