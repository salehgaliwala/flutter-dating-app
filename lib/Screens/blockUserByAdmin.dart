import 'package:flutter/material.dart';
import 'package:seting/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

class BlockUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondryColor.withOpacity(.5),
      body: AlertDialog(
        actionsPadding: const EdgeInsets.only(right: 10),
        backgroundColor: Colors.white,
        actions: const [
          Text("for more info visit: https://help.deligence.com"),
        ],
        title: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Container(
                      height: 50,
                      width: 100,
                      child: Image.asset(
                        "asset/seting-Logo-BP.png",
                        fit: BoxFit.contain,
                      )),
                )),
            Text(
              "sorry, you can't access the application!".tr().toString(),
              style: TextStyle(color: primaryColor),
            ),
          ],
        ),
        content: Text(
            "you're blocked by the admin and your profile will also not appear for other users.".tr().toString()),
      ),
    );
  }
}
