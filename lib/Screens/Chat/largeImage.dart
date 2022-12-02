import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seting/util/color.dart';

class LargeImage extends StatelessWidget {
  final largeImage;
  const LargeImage(this.largeImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor),
        backgroundColor: primaryColor,
        body: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: Colors.white),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CachedNetworkImage(
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CupertinoActivityIndicator(
                            radius: 20,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        height: MediaQuery.of(context).size.height * .75,
                        width: MediaQuery.of(context).size.width,
                        imageUrl: largeImage ?? '',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                          backgroundColor: primaryColor,
                          child: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context)),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
