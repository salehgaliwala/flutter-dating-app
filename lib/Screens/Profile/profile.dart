import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
//import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:seting/Screens/Information.dart';
import 'package:seting/Screens/Payment/paymentDetails.dart';
import 'package:seting/Screens/Profile/EditProfile.dart';
import 'package:seting/Screens/Profile/settings.dart';
import 'package:seting/models/user_model.dart';
import 'package:seting/util/color.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../Payment/subscriptions.dart';
import 'package:easy_localization/easy_localization.dart';

final List adds = [
  {
    'icon': Icons.whatshot,
    'color': Colors.indigo,
    'title': "Get matches faster".tr().toString(),
    'subtitle': "Boost your profile once a month".tr().toString(),
  },
  {
    'icon': Icons.favorite,
    'color': Colors.lightBlueAccent,
    'title': "more likes".tr().toString(),
    'subtitle': "Get free rewindes".tr().toString(),
  },
  {
    'icon': Icons.star_half,
    'color': Colors.amber,
    'title': "Increase your chances".tr().toString(),
    'subtitle': "Get unlimited free likes".tr().toString(),
  },
  {
    'icon': Icons.location_on,
    'color': Colors.purple,
    'title': "Swipe around the world".tr().toString(),
    'subtitle': "Passport to anywhere with seting".tr().toString(),
  },
  {
    'icon': Icons.vpn_key,
    'color': Colors.orange,
    'title': "Control your profile".tr().toString(),
    'subtitle': "highly secured".tr().toString(),
  }
];

class Profile extends StatefulWidget {
  final User currentUser;
  final bool isPuchased;
  final Map items;
  final List<PurchaseDetails> purchases;
  const Profile(this.currentUser, this.isPuchased, this.purchases, this.items);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final EditProfileState _editProfileState = EditProfileState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            const SizedBox(
              height: 10,
            ),
            Hero(
              tag: "abc",
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: secondryColor,
                  child: Material(
                    color: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        InkWell(
                          onTap: () => showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return Info(widget.currentUser,
                                    widget.currentUser, null);
                              }),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                80,
                              ),
                              child: CachedNetworkImage(
                                height: 150,
                                width: 150,
                                fit: BoxFit.fill,
                                imageUrl: widget.currentUser.imageUrl!.isNotEmpty
                                    ? widget.currentUser.imageUrl![0] ?? ''
                                    : '',
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
                                      "Enable to load".tr().toString(),
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
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            color: primaryColor,
                            child: IconButton(
                                alignment: Alignment.center,
                                icon: const Icon(
                                  Icons.photo_camera,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _editProfileState.source(
                                      context, widget.currentUser, true);
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Text(
              widget.currentUser.name != null && widget.currentUser.age != null
                  ? "${widget.currentUser.name}, ${widget.currentUser.age}"
                  : "",
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            ),
            Text(
              widget.currentUser.editInfo!['job_title'] != null
                  ? "${widget.currentUser.editInfo!['job_title']}  ${widget.currentUser.editInfo!['company'] != null ? "at ${widget.currentUser.editInfo!['company']}" : ""}"
                  : "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 20),
            ),
            Text(
              widget.currentUser.editInfo!['university'] != null
                  ? "${widget.currentUser.editInfo!['university']}"
                  : "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 20),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .45,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: FloatingActionButton(
                                heroTag: UniqueKey(),
                                splashColor: secondryColor,
                                backgroundColor: primaryColor,
                                child: const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {
                                  _editProfileState.source(
                                      context, widget.currentUser, false);
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Add media".tr().toString(),
                              style: TextStyle(color: secondryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 30, top: 30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: <Widget>[
                            FloatingActionButton(
                                splashColor: secondryColor,
                                heroTag: UniqueKey(),
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.settings,
                                  color: secondryColor,
                                  size: 28,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          maintainState: true,
                                          builder: (context) => Settings(
                                              widget.currentUser,
                                              widget.isPuchased,
                                              widget.items)));
                                }),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Settings".tr().toString(),
                                style: TextStyle(color: secondryColor),
                              ),
                            )
                          ],
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(right: 30, top: 30),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: <Widget>[
                            FloatingActionButton(
                                heroTag: UniqueKey(),
                                splashColor: secondryColor,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  color: secondryColor,
                                  size: 28,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              EditProfile(widget.currentUser)));
                                }),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Edit Info".tr().toString(),
                                style: TextStyle(color: secondryColor),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 210),
                    child: SizedBox(
                      height: 120,
                      child: CustomPaint(
                        painter: CurvePainter(),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        height: 100,
                        width: MediaQuery.of(context).size.width * .85,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Swiper(
                            key: UniqueKey(),
                            curve: Curves.linear,
                            autoplay: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int index2) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          adds[index2]["icon"],
                                          color: adds[index2]["color"],
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          adds[index2]["title"],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      adds[index2]["subtitle"],
                                      textAlign: TextAlign.center,
                                    ),
                                  ]);
                            },
                            itemCount: adds.length,
                            pagination: SwiperPagination(
                                alignment: Alignment.bottomCenter,
                                builder: DotSwiperPaginationBuilder(
                                    activeSize: 10,
                                    color: secondryColor,
                                    activeColor: primaryColor)),
                            control: SwiperControl(
                              size: 20,
                              color: primaryColor,
                              disableColor: secondryColor,
                            ),
                            loop: false,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              primaryColor.withOpacity(.5),
                              primaryColor.withOpacity(.8),
                              primaryColor,
                              primaryColor
                            ])),
                    height: MediaQuery.of(context).size.height * .065,
                    width: MediaQuery.of(context).size.width * .75,
                    child: Center(
                        child: Text(
                      widget.isPuchased
                          ? "Check Payment Details".tr().toString()
                          : "Subscribe Plan".tr().toString(),
                      style: TextStyle(
                          fontSize: 15,
                          color: textColor,
                          fontWeight: FontWeight.bold),
                    ))),
                onTap: () async {
                  if (widget.isPuchased) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              PaymentDetails(widget.purchases)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Subscription(
                              widget.currentUser, null, widget.items)),
                    );
                  }
                  // showCupertinoDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return Dialog(
                  //         insetAnimationDuration: Duration(seconds: 3),
                  //         elevation: 25,
                  //         insetPadding: EdgeInsets.all(20),
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(20)),
                  //         insetAnimationCurve: Curves.bounceInOut,
                  //         backgroundColor: Colors.white,
                  //         child: Subscription(),
                  //       );
                  //    });
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = secondryColor.withOpacity(.4);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;

    var startPoint = Offset(0, -size.height / 2);
    var controlPoint1 = Offset(size.width / 4, size.height / 3);
    var controlPoint2 = Offset(3 * size.width / 4, size.height / 3);
    var endPoint = Offset(size.width, -size.height / 2);

    var path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
