import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seting/Screens/Chat/Matches.dart';
import 'package:seting/Screens/Chat/chatPage.dart';
import 'package:seting/models/user_model.dart';
import 'package:seting/util/color.dart';
import 'package:intl/intl.dart';

class RecentChats extends StatelessWidget {
  final db = FirebaseFirestore.instance;
  final User currentUser;
  final List<User> matches;

  RecentChats(this.currentUser, this.matches);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                //   topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: ListView(
                  physics: const ScrollPhysics(),
                  children: matches
                      .map((index) => GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => ChatPage(
                                  chatId: chatId(currentUser, index),
                                  sender: currentUser,
                                  second: index,
                                ),
                              ),
                            ),
                            child: StreamBuilder(
                                stream: db
                                    .collection("chats")
                                    .doc(chatId(currentUser, index))
                                    .collection('messages')
                                    .orderBy('time', descending: true)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container(
                                      child: const Padding(
                                        padding: EdgeInsets.all(18.0),
                                        child: CupertinoActivityIndicator(),
                                      ),
                                    );
                                  } else if (snapshot.data!.docs.isEmpty) {
                                    return Container();
                                  }
                                  index.lastmsg =
                                      snapshot.data!.docs[0]['time'];
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0, bottom: 5.0, right: 20.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    decoration: BoxDecoration(
                                      color: snapshot.data!.docs[0]
                                                      ['sender_id'] !=
                                                  currentUser.id &&
                                              !snapshot.data!.docs[0]
                                                  ['isRead']
                                          ? primaryColor.withOpacity(.1)
                                          : secondryColor.withOpacity(.2),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: secondryColor,
                                        radius: 30.0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          child: CachedNetworkImage(
                                            imageUrl: index.imageUrl![0] ?? '',
                                            useOldImageOnUrlChange: true,
                                            placeholder: (context, url) =>
                                                const CupertinoActivityIndicator(
                                              radius: 15,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        index.name!,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        snapshot.data!.docs[0]['image_url']
                                                    .toString().isNotEmpty
                                            ? "Photo"
                                            : snapshot.data!.docs[0]
                                                ['text'],
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data!.docs[0]
                                                        ["time"] !=
                                                    null
                                                ? DateFormat.MMMd('en_US')
                                                    .add_jm()
                                                    .format(snapshot.data!
                                                        .docs[0]["time"]
                                                        .toDate())
                                                    .toString()
                                                : "",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          snapshot.data!.docs[0]
                                                          ['sender_id'] !=
                                                      currentUser.id &&
                                                  !snapshot.data!.docs[0]
                                                      ['isRead']
                                              ? Container(
                                                  width: 40.0,
                                                  height: 20.0,
                                                  decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ),
                                                  alignment: Alignment.center,
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
                                          snapshot.data!.docs[0]
                                                      ['sender_id'] ==
                                                  currentUser.id
                                              ? !snapshot.data!.docs[0]
                                                      ['isRead']
                                                  ? Icon(
                                                      Icons.done,
                                                      color: secondryColor,
                                                      size: 15,
                                                    )
                                                  : Icon(
                                                      Icons.done_all,
                                                      color: primaryColor,
                                                      size: 15,
                                                    )
                                              : const Text("")
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ))
                      .toList()),
            )));
  }
}
